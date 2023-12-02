import os
import re


def clean_folder_name(folder_name):
    cleaned_name = folder_name.replace("-", "_")
    return cleaned_name


def process_cmake_file(file_path, output_file):
    with open(file_path, "r") as file:
        content = file.read()
        matches_exec = re.findall(r"add_executable\((.*?)\)", content)
        matches_lib = re.findall(r"add_library\((.*?)\)", content)
        matches = matches_exec + matches_lib

        folder_name = clean_folder_name(os.path.basename(os.path.dirname(file_path)))
        parent_folder = clean_folder_name(
            os.path.basename(os.path.dirname(os.path.dirname(file_path)))
        )

        output_file.write(
            f"const {parent_folder}_{folder_name} = b.addStaticLibrary(.{{\n"
        )
        output_file.write(f'    .name = "{parent_folder}_{folder_name}",\n')
        output_file.write("    .target = target,\n")
        output_file.write("    .optimize = optimize,\n")
        output_file.write("});\n")

        if matches:
            has_cpp_files = any(
                re.search(r"\S+\.cc|\S+\.cpp", match) for match in matches
            )
            if has_cpp_files:
                output_file.write(f"{parent_folder}_{folder_name}.linkLibCpp();\n")
            else:
                output_file.write(f"{parent_folder}_{folder_name}.linkLibC();\n")

            has_files = any(
                re.search(r"\S+\.cc|\S+\.cpp|\S+\.c|\S+\.s", match) for match in matches
            )

            if has_files:
                output_file.write(
                    f"{parent_folder}_{folder_name}.addCSourceFiles(.{{.files = &[_][]const u8{{"
                )

                for match in matches:
                    files = re.findall(r"\S+\.cc|\S+\.cpp|\S+\.c|\S+\.s", match)

                    for f in files:
                        file_rel_path = os.path.relpath(
                            os.path.join(os.path.dirname(file_path), f), os.getcwd()
                        )
                        output_file.write(f'"{file_rel_path}", ')
                output_file.write("}});\n")
                output_file.write("\n")


def process_subdirectories(file_path, output_file):
    with open(file_path, "r") as file:
        content = file.read()
        matches = re.findall(
            r"add_subdirectory\((.*?)\)", content
        )  # Trouve les blocs add_subdirectory

        if matches:
            folder_name = clean_folder_name(
                os.path.basename(os.path.dirname(file_path))
            )
            parent_folder = clean_folder_name(
                os.path.basename(os.path.dirname(os.path.dirname(file_path)))
            )
            for match in matches:
                # output_file.write(
                #     f"{parent_folder}_{folder_name}.linkLibrary({folder_name}_{clean_folder_name(match)});\n"
                # )
                if "/" in match:
                    parts = match.split("/")
                    output_file.write(
                        f"{parent_folder}_{folder_name}.linkLibrary({clean_folder_name(parts[-2])}_{clean_folder_name(parts[-1])});\n"
                    )
                else:
                    output_file.write(
                        f"{parent_folder}_{folder_name}.linkLibrary({folder_name}_{clean_folder_name(match)});\n"
                    )
            output_file.write("\n")


# def process_project_directory(directory_path, output_file):
#     for root, dirs, files in os.walk(directory_path):
#         for file in files:
#             if file == "CMakeLists.txt":
#                 file_path = os.path.join(root, file)
#                 process_cmake_file(file_path, output_file)
#                 process_subdirectories(file_path, output_file)


def process_project_directory(directory_path, output_file):
    directories = []
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file == "CMakeLists.txt":
                directories.append(root)

    directories.reverse()  # Inverser l'ordre

    for dir_path in directories:
        file_path = os.path.join(dir_path, "CMakeLists.txt")
        process_cmake_file(file_path, output_file)
        process_subdirectories(file_path, output_file)


# def insert_output_into_build_zig(output_file_path, build_zig_path):
#     with open(output_file_path, "r") as output_file:
#         output_content = output_file.read()

#     with open(build_zig_path, "r") as build_zig:
#         build_content = build_zig.read()

#     # Insérer le contenu de output.txt entre "BEGIN" et "END" dans build.zig
#     begin_marker = "// BEGIN\n"
#     end_marker = "// END\n"
#     begin_index = build_content.find(begin_marker) + len(begin_marker)
#     end_index = build_content.find(end_marker)

#     updated_build_content = (
#         build_content[:begin_index]
#         + output_content.strip()
#         + "\n\n"
#         + build_content[end_index:]  # Ajout du contenu de output.txt
#     )

#     # Écriture du contenu mis à jour dans le fichier build.zig
#     with open(build_zig_path, "w") as build_zig:
#         build_zig.write(updated_build_content)


# def main():
#     output_file_path = "output.txt"
#     with open(output_file_path, "w") as output_file:
#         project_directory = os.getcwd()
#         process_project_directory(project_directory, output_file)


def main():
    output_file_path = "output.txt"
    build_zig_path = "build.zig"
    project_directory = os.getcwd()

    # Processus habituel pour générer output.txt
    with open(output_file_path, "w") as output_file:
        process_project_directory(project_directory, output_file)

    # Lecture du contenu de output.txt
    with open(output_file_path, "r") as output_file:
        output_content = output_file.read()

    # Lecture du contenu de build.zig
    with open(build_zig_path, "r") as build_zig:
        build_content = build_zig.read()

    # Trouver les positions des marqueurs "BEGIN" et "END"
    begin_marker = "// BEGIN\n"
    end_marker = "// END\n"
    begin_index = build_content.find(begin_marker) + len(begin_marker)
    end_index = build_content.find(end_marker)

    # Insérer le contenu de output.txt entre les balises "BEGIN" et "END" dans build.zig
    updated_build_content = (
        build_content[:begin_index]
        + output_content.strip()
        + "\n\n"
        + build_content[end_index:]  # Ajout du contenu de output.txt
    )

    # Écriture du contenu mis à jour dans le fichier build.zig
    with open(build_zig_path, "w") as build_zig:
        build_zig.write(updated_build_content)


if __name__ == "__main__":
    main()


if __name__ == "__main__":
    main()
