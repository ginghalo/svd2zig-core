const std = @import("std");
const mem = std.mem;
const Type = std.builtin.Type;
const Allocator = mem.Allocator;
const Writer = std.fs.File.Writer;

pub const Error = error{
    REG_INTERRUPT_IS_NOT_STRUCT,
};

pub fn generate(_reg: type, _writer: Writer, _vector_len: usize) !void {
    const ints = @typeInfo(_reg.interrupts);
    if (ints != .Struct) return Error.REG_INTERRUPT_IS_NOT_STRUCT;

    const decls = ints.Struct.decls;
    const len = decls.len;
    comptime var decl_value: [len]usize = undefined;
    comptime {
        for (0..len) |i| {
            decl_value[i] = @field(_reg.interrupts, decls[i].name);
        }
    }

    var declvalue: [decl_value.len]usize = undefined;
    for (0..len) |i| declvalue[i] = decl_value[i];

    for (0.._vector_len) |i| {
        const map_index = mem.indexOfScalar(usize, &declvalue, i);
        if (map_index) |mindex| {
            try _writer.print("export fn {s}() void {{}}\n", .{decls[mindex].name});
        } else {}
    }

    try _writer.print("export const {s}_vector_table linksection(\".{s}_vectors\") = [_]*allowzero const fn () callconv(.C) void{{\n", .{ _reg.device_name, _reg.device_name });

    for (0.._vector_len) |i| {
        const map_index = mem.indexOfScalar(usize, &declvalue, i);
        if (map_index) |mindex| {
            try _writer.print("{s},\n", .{decls[mindex].name});
        } else {
            try _writer.writeAll("@ptrFromInt(0), // Reserved\n");
        }
    }

    try _writer.print("}};\n", .{});
}

// test "g" {
//     const f = try std.fs.cwd().createFile("0.zig", .{});
//     try generate(reg, f.writer(), 60);
// }
