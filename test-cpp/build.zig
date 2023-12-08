// const std = @import("std");

// pub fn build(b: *std.Build) void {
//     const target = b.standardTargetOptions(.{});
//     const optimize = b.standardOptimizeOption(.{});

//     // const exe = b.addExecutable(.{
//     //     .name = "helloworld",
//     //     .root_source_file = .{ .path = "main.cpp" },
//     //     .target = target,
//     //     .optimize = optimize,
//     // });
//     // // link with the standard library libcpp
//     // exe.linkLibCpp();
//     // exe.addIncludePath("src");
//     // exe.addCSourceFile("src/hello.cpp", &.{});
//     // b.installArtifact(exe);

//     const function1 = b.addStaticLibrary(.{
//         .name = "function1",
//         .target = target,
//         .optimize = optimize,
//     });
//     function1.linkLibCpp();
//     function1.addCSourceFiles(
//         .{ .files = &[_][]const u8{"functions1.cpp"} },
//     );

//     const function2 = b.addStaticLibrary(.{
//         .name = "function2",
//         .target = target,
//         .optimize = optimize,
//     });
//     function2.linkLibCpp();
//     function2.addCSourceFiles(
//         .{ .files = &[_][]const u8{"functions2.cpp"} },
//     );
// }

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const function1 = b.addStaticLibrary(.{
        .name = "function1",
        .target = target,
        .optimize = optimize,
    });
    function1.linkLibCpp();
    function1.addCSourceFiles(
        .{ .files = &[_][]const u8{"functions1.cpp"} },
    );

    const function2 = b.addStaticLibrary(.{
        .name = "function2",
        .target = target,
        .optimize = optimize,
    });
    function2.linkLibCpp();
    function2.addCSourceFiles(
        .{ .files = &[_][]const u8{"functions2.cpp"} },
    );

    const exe = b.addExecutable(.{
        .name = "test_cpp",
        .target = target,
        .optimize = optimize,
    });
    // link with the standard library libcpp
    exe.linkLibCpp();

    exe.addCSourceFiles(.{ .files = &[_][]const u8{
        "main.cpp",
    } });
    exe.linkLibrary(function1);
    exe.linkLibrary(function2);

    b.installArtifact(exe);

    // const exe = b.addExecutable(.{
    //     .name = "helloworld",
    //     // .root_source_file = .{ .path = "src/main.zig" },
    //     .target = target,
    //     .optimize = optimize,
    // });
    // // link with the standard library libcpp
    // exe.linkLibCpp();
    // // exe.addIncludePath("src");
    // // exe.addCSourceFile("src/hello.cpp", &.{});

    // exe.addCSourceFiles(.{ .files = &[_][]const u8{
    //     "hello.cpp",
    // } });
    // b.installArtifact(exe);
}
