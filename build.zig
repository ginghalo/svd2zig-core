const std = @import("std");

pub fn build(b: *std.Build) void {
    b.addModule("svd2zig-core", .{
        .root_source_file = b.path("src/zig-generator.zig"),
    });
}
