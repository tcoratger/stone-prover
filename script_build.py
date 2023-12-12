import os
import re
import subprocess

flags = """
    "-Wall",
    "-Wextra",
    "-fPIC",
    "-I./src",
    "-I/tmp/benchmark/include",
    "-I/tmp/gflags/include",
    "-I/tmp/glog/src",
    "-I/tmp/glog",
    "-I/tmp/googletest/googletest/include",
    "-I/tmp/googletest/googlemock/include",
    "-fconstexpr-steps=20000000",
"""

build_setup = """const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
"""

install_exe = """const install_exe_prover = b.addInstallArtifact(
    cpu_air_prover,
    .{},
);
b.getInstallStep().dependOn(&install_exe_prover.step);

const install_exe_verifier = b.addInstallArtifact(
    cpu_air_prover,
    .{},
);
b.getInstallStep().dependOn(&install_exe_verifier.step); }"""

prover_exec = (
    """var cpu_air_prover = b.addExecutable(.{
    .name = "cpu_air_prover",
    .target = target,
    .optimize = optimize,
});
cpu_air_prover.addCSourceFile(.{
    .file = .{
        .path = "src/starkware/main/cpu/cpu_air_prover_main.cc"
    },
    .flags = &.{
    "-std=c++17","""
    + flags
    + """
    },
});
cpu_air_prover.linkLibCpp();
cpu_air_prover.linkSystemLibrary("dw");
cpu_air_prover.linkSystemLibrary("glog");
cpu_air_prover.linkSystemLibrary("gflags");
"""
)

verifier_exec = (
    """var cpu_air_verifier = b.addExecutable(.{
    .name = "cpu_air_verifier",
    .target = target,
    .optimize = optimize,
});
cpu_air_verifier.addCSourceFile(.{
    .file = .{
        .path = "src/starkware/main/cpu/cpu_air_verifier_main.cc"
    },
    .flags = &.{
    "-std=c++17","""
    + flags
    + """
    },
});
cpu_air_verifier.linkLibCpp();
cpu_air_verifier.linkSystemLibrary("dw");
cpu_air_verifier.linkSystemLibrary("glog");
cpu_air_verifier.linkSystemLibrary("gflags");
"""
)

gtest_exec = (
    """var gtest = b.addExecutable(.{
    .name = "gtest",
    .target = target,
    .optimize = optimize,
});
gtest.addCSourceFile(.{
    .file = .{
        .path = "src/starkware/gtest/gtest_main.cc"
    },
    .flags = &.{
    "-std=c++17","""
    + flags
    + """
    },
});
gtest.linkLibCpp();
gtest.linkSystemLibrary("dw");
gtest.linkSystemLibrary("glog");
gtest.linkSystemLibrary("gflags");
"""
)


def clean_folder_name(folder_name):
    """
    Clean the folder name by replacing dashes with underscores.

    Args:
        folder_name (str): The folder name to be cleaned.

    Returns:
        str: The cleaned folder name.
    """
    cleaned_name = folder_name.replace("-", "_")
    return cleaned_name


def process_cmake_file(file_path, output_file):
    """
    Process the content of a CMakeLists.txt file.

    Args:
        file_path (str): The path to the CMakeLists.txt file.
        output_file (_io.TextIOWrapper): The output file to write to.
    """
    # Reading the content of the CMakeLists.txt file
    with open(file_path, "r") as file:
        content = file.read()

        # Find 'add_executable' and 'add_library' blocks
        matches_exec = re.findall(r"add_executable\((.*?)\)", content)
        matches_lib = re.findall(r"add_library\((.*?)\)", content)
        matches = matches_exec + matches_lib

        # Extract folder names
        folder_name = clean_folder_name(os.path.basename(os.path.dirname(file_path)))
        parent_folder = clean_folder_name(
            os.path.basename(os.path.dirname(os.path.dirname(file_path)))
        )

        if (
            f"{parent_folder}_{folder_name}" != "main_cpu"
            and f"{folder_name}" != "gtest"
        ):
            # Write static library declaration to output_file
            output_file.write(
                f"const {parent_folder}_{folder_name} = b.addStaticLibrary(.{{\n"
            )
            output_file.write(f'    .name = "{parent_folder}_{folder_name}",\n')
            output_file.write("    .target = target,\n")
            output_file.write("    .optimize = optimize,\n")
            output_file.write("});\n")
            output_file.write(
                f"cpu_air_prover.linkLibrary({parent_folder}_{folder_name});\n"
            )
            output_file.write(
                f"cpu_air_verifier.linkLibrary({parent_folder}_{folder_name});\n"
            )
            output_file.write(f"gtest.linkLibrary({parent_folder}_{folder_name});\n")

            # Process file matches
            if matches:
                # Check for .cc or .cpp files
                has_cpp_files = any(
                    re.search(r"\S+\.cc|\S+\.cpp", match) for match in matches
                )

                # has_c_files = any(re.search(r"\S+\.c", match) for match in matches)

                # Link based on presence of .cc or .cpp files
                if has_cpp_files:
                    output_file.write(f"{parent_folder}_{folder_name}.linkLibCpp();\n")
                else:
                    output_file.write(f"{parent_folder}_{folder_name}.linkLibC();\n")

                output_file.write(
                    f'{parent_folder}_{folder_name}.linkSystemLibrary("dw");\n'
                )
                output_file.write(
                    f'{parent_folder}_{folder_name}.linkSystemLibrary("glog");\n'
                )
                output_file.write(
                    f'{parent_folder}_{folder_name}.linkSystemLibrary("gflags");\n'
                )

                # Process files found in matches
                has_files = any(
                    re.search(r"\S+\.cc|\S+\.cpp|\S+\.c|\S+\.s", match)
                    for match in matches
                )
                if has_files:
                    output_file.write(
                        f"{parent_folder}_{folder_name}.addCSourceFiles(.{{.files = &[_][]const u8{{"
                    )

                    # Write file paths to output_file
                    for match in matches:
                        files = re.findall(r"\S+\.cc|\S+\.cpp|\S+\.c|\S+\.s", match)

                        for f in files:
                            file_rel_path = os.path.relpath(
                                os.path.join(os.path.dirname(file_path), f), os.getcwd()
                            )
                            output_file.write(f'"{file_rel_path}", ')

                    output_file.write("}, .flags = &.{")
                    if has_cpp_files:
                        output_file.write('"-std=c++17",')
                    output_file.write(flags)
                    output_file.write("}});\n")
                    output_file.write("\n")


def process_subdirectories(file_path, output_file):
    """
    Process subdirectories mentioned in the CMakeLists.txt file.

    Args:
        file_path (str): The path to the CMakeLists.txt file.
        output_file (_io.TextIOWrapper): The output file to write to.
    """
    with open(file_path, "r") as file:
        content = file.read()
        matches = re.findall(
            r"add_subdirectory\((.*?)\)", content
        )  # Find 'add_subdirectory' blocks

        if matches:
            folder_name = clean_folder_name(
                os.path.basename(os.path.dirname(file_path))
            )
            parent_folder = clean_folder_name(
                os.path.basename(os.path.dirname(os.path.dirname(file_path)))
            )
            for match in matches:
                if "/" in match:
                    parts = match.split("/")
                    output_file.write(
                        f"{parent_folder}_{folder_name}.linkLibrary({clean_folder_name(parts[-2])}_{clean_folder_name(parts[-1])});\n"
                    )
                elif (
                    f"{folder_name}_{clean_folder_name(match)}" != "main_cpu"
                    and f"{clean_folder_name(match)}" != "gtest"
                ):
                    output_file.write(
                        f"{parent_folder}_{folder_name}.linkLibrary({folder_name}_{clean_folder_name(match)});\n"
                    )
            output_file.write("\n")


def process_project_directory(directory_path, output_file):
    """
    Process the entire project directory.

    Args:
        directory_path (str): The path to the project directory.
        output_file (_io.TextIOWrapper): The output file to write to.
    """
    directories = []
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file == "CMakeLists.txt":
                directories.append(root)

    directories.reverse()  # Reverse the order

    for dir_path in directories:
        file_path = os.path.join(dir_path, "CMakeLists.txt")
        process_cmake_file(file_path, output_file)
        process_subdirectories(file_path, output_file)


def main():
    """
    Main function to generate output.txt and update build.zig.
    """
    output_file_path = "output.txt"
    build_zig_path = "build.zig"
    project_directory = os.getcwd()

    # Generate output.txt
    with open(output_file_path, "w") as output_file:
        process_project_directory(project_directory, output_file)

    # Read output.txt content
    with open(output_file_path, "r") as output_file:
        output_content = output_file.read()

    # Write updated content to build.zig
    with open(build_zig_path, "w") as build_zig:
        build_zig.write(
            (
                build_setup
                + "\n\n"
                + prover_exec
                + "\n\n"
                + verifier_exec
                + "\n\n"
                + gtest_exec
                + "\n\n"
                + output_content.strip()
                + "\n\n"
                + install_exe
                + "\n\n"
            )
        )

    # Run zig fmt command to format build.zig
    subprocess.run(["zig", "fmt", "build.zig"], check=True)


if __name__ == "__main__":
    main()
