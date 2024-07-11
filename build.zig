const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("svd2zig-generator", .{
        .root_source_file = b.path("src/zig-generator.zig"),
        .target = target,
        .optimize = optimize,
    });
    _ = b.addModule("vector_table-generator", .{
        .root_source_file = b.path("src/vector_table-generator.zig"),
        .target = target,
        .optimize = optimize,
    });
}
