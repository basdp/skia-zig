const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    var target = b.standardTargetOptions(.{});

    if (target.result.os.tag == .windows) {
        // Force the MSVC ABI, as Skia requires that
        target.query.abi = .msvc;
    }

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    var module = b.addModule("skia-zig", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/main.zig"),
    });

    switch (target.result.os.tag) {
        .windows => {
            var path: [128:0]u8 = undefined;
            module.addLibraryPath(b.path(try std.fmt.bufPrint(&path, "skia/lib/win-{s}", .{@tagName(target.result.cpu.arch)})));
        },
        else => return error.PlatformNotSupported,
    }
    module.addIncludePath(b.path("skia"));
    module.linkSystemLibrary("skia", .{ .preferred_link_mode = .static });
    module.link_libc = true;
}
