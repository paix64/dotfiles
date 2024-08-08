import subprocess


def get_installed_packages():
    try:
        result = subprocess.run(
            ["pacman", "-Qeq"], stdout=subprocess.PIPE, text=True, check=True
        )
        installed_packages = [line for line in result.stdout.splitlines()]
        return installed_packages

    except subprocess.CalledProcessError as e:
        print(f"Error executing pacman -Qe: {e}")
        return []


def read_config_packages(file_path):
    try:
        with open(file_path, "r") as file:
            config_packages = [
                line.split()[0].strip()
                for line in file
                if line.strip() and not line.strip().startswith("#")
            ]
            file.seek(0)
            system_packages = [
                line.split()[0].strip()[2:]
                for line in file
                if line.strip().startswith("##")
            ]

        return config_packages, system_packages

    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return []


def compare_packages(installed_packages, config_packages, system_packages):
    installed_set = set(installed_packages)
    config_set = set(config_packages)
    system_set = set(system_packages)

    blacklist = ["#", "pipewire"]  # remove unwanted
    config_set = config_set - set(blacklist)

    not_in_config = installed_set - config_set - system_set
    not_installed = config_set - installed_set

    return not_in_config, not_installed


def main():

    config_packages, system_packages = read_config_packages("packages.conf")
    if not config_packages:
        print("Error reading the given packages file.")
        return

    installed_packages = get_installed_packages()
    if not installed_packages:
        print("Error retrieving installed packages.")
        return

    not_in_given, not_installed = compare_packages(
        installed_packages, config_packages, system_packages
    )

    if not_in_given:
        print("Packages installed but not in packages.conf")
        for pkg in not_in_given:
            print(pkg)
    else:
        print("All installed packages are in the packages.conf.")

    if not_installed:
        print("\nPackages in the config but not installed:")
        for pkg in not_installed:
            print(pkg)
    else:
        print("All config packages are installed.")


if __name__ == "__main__":
    main()
