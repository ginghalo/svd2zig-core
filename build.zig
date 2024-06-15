const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("svd2zig-core", .{
        .root_source_file = b.path("src/zig-generator.zig"),
        .target = target,
        .optimize = optimize,
    });
}
