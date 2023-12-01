import os


def traverse_directory(directory):
    with open("log_cc_files.txt", "w") as log_file:
        for current_folder, _, files in os.walk(directory):
            cc_files = [
                file for file in files if file.endswith(".cc") or file.endswith(".c")
            ]
            if cc_files:
                relative_path = os.path.relpath(
                    current_folder, directory
                )  # Getting the relative path
                log_file.write(f"Folder: {relative_path}\n")
                for file in cc_files:
                    log_file.write(f"    {file}\n")


# Getting the current working directory
current_directory = os.getcwd()

traverse_directory(current_directory)


def generate_library_commands(directory):
    with open("log_fn_files.txt", "w") as log_file:
        for current_folder, _, files in os.walk(directory):
            cc_files = [
                file for file in files if file.endswith(".cc") or file.endswith(".c")
            ]
            if cc_files:
                relative_path = os.path.relpath(
                    current_folder, directory
                )  # Getting the relative path

                log_file.write(f"\n")
                for file in cc_files:
                    file_extension = file.endswith(".cc")
                    file_name = file.split(".")[0]  # Removing file extension
                    log_file.write(
                        f'addLibrary(b, "{file_name}", "{relative_path}/{file}", {str(file_extension).lower()});\n'
                    )


generate_library_commands(current_directory)
