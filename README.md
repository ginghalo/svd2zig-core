# svd2zig-core
the core of svd2zig, start from zig version '0.13.0'

## method of import
cmd
```
zig fetch https://github.com/ginghalo/svd2zig-core/archive/refs/tags/0.1.0.zip
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
    unit_tests.root_module.addImport("svd2zig", @"svd2zig-core".module("svd2zig-core"));
    // ...
}
```
```zig
//! unitest.zig
const generator = @import("svd2zig");
test "unitest"{
    const readfile_name = "example.svd";
    const writefile_name = "example.zig";
    var r = try std.fs.cwd().openFile(readfile_name, .{ .mode = .read_only });
    defer r.close();
    var w = try std.fs.cwd().createFile(writefile_name, .{});
    defer w.close();

    try generator.generate(allocator, &r.reader(), &w.writer());
}
```

## version of zig

0.13.0
