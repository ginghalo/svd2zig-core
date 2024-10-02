# svd2zig-core
the core of svd2zig, start from zig version '0.13.0'

## method of import
cmd
```
zig fetch https://github.com/ginghalo/svd2zig-core/archive/refs/tags/0.1.1.zip
```
zig file
```zig
//! build.zig
// ...
pub fn build(b: *std.Build) void {
    // ...
    const @"svd2zig-core" = b.dependency("svd2zig-core", .{
        .target = target,
        .optimize = optimize,
    });
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("unitest.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.root_module.addImport("svd2zig-generator", @"svd2zig-core".module("svd2zig-generator"));
    unit_tests.root_module.addImport("vector_table-generator", @"svd2zig-core".module("vector_table-generator"));
    // ...
}
```
```zig
//! unitest.zig
const svd2zig_generator = @import("svd2zig-generator");
test "svd2zig_generator"{
    const readfile_name = "f103.svd";
    const writefile_name = "reg-f103.zig";
    var r = try std.fs.cwd().openFile(readfile_name, .{ .mode = .read_only });
    defer r.close();
    var w = try std.fs.cwd().createFile(writefile_name, .{});
    defer w.close();

    try svd2zig_generator.generate(allocator, &r.reader(), &w.writer());
}
const vector_table_generator = @import("vector_table-generator");
test "vector_table_generator"{
    const reg = @import("reg-f103.zig");
    const writefile_name = "vector_table-f103.zig";
    var w = try std.fs.cwd().createFile(writefile_name, .{});
    defer w.close();

    try vector_table_generator.generate(reg, w.writer(), 60);// 60 is the len of vector table of low/medium/high capatity of stm32f103
}
```

## version of zig

0.13.0
