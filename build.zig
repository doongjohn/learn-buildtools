const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const linenoise = b.addStaticLibrary("linenoise", null);
    {
        linenoise.setTarget(target);
        linenoise.addIncludePath("src/lib/linenoise");
        linenoise.addCSourceFiles(&[_][]const u8{
            "src/lib/linenoise/utf8.c",
            "src/lib/linenoise/stringbuf.c",
            "src/lib/linenoise/linenoise.c",
        }, &[_][]const u8{
            "-Wall",
            "-DUSE_UTF8",
        });
        linenoise.linkLibC();
    }

    const exe = b.addExecutable("app", null);
    {
        exe.setTarget(target);
        exe.addIncludePath("src");
        exe.addIncludePath("src/lib/linenoise");
        exe.addCSourceFile("src/main.c", &[_][]const u8{
            "-Wall",
        });
        exe.linkLibrary(linenoise);
        exe.linkLibC();
        exe.install();
    }

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
