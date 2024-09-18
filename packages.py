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
            packages = [
                line.split()[0].strip()
                for line in file
                if line.strip() and not line.startswith("#")
            ]

        return packages

    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return []


def compare_packages(installed_packages, pacman_packages, aur_packages):
    aur_set = set(aur_packages)
    pacman_set = set(pacman_packages)

    installed_set = set([pkg for pkg in installed_packages if not pkg.startswith("cosmic-")])
    
    blacklist = ["linux", "linux-firmware", "linux-headers", "efibootmgr", "base",
                "base-devel", "intel-ucode", "networkmanager",
                "network-manager-applet", "nano", "vim", "sof-firmware", "pipewire",
                "dkms", "nvidia-open-dkms", "hyprland", "wget"]
    

    blacklist_set = set(blacklist)
    not_in_config = installed_set - pacman_set - aur_set - blacklist_set
    not_installed = pacman_set.union(aur_set).difference(installed_set)

    return not_in_config, not_installed


def main():
    pacman_packages = read_config_packages("pacman.conf")
    if not pacman_packages:
        print("Error reading the given pacman package file.")
        return

    aur_packages = read_config_packages("aur.conf")
    if not aur_packages:
        print("Error reading the given aur package file.")
        return

    installed_packages = get_installed_packages()
    if not installed_packages:
        print("Error retrieving installed packages.")
        return

    not_in_given, not_installed = compare_packages(
        installed_packages, pacman_packages, aur_packages
    )

    all_in_config = False
    all_config_installed = False

    print(f":: {len(installed_packages)} packages are installed.")
    print(f":: {len(aur_packages)} AUR packages installed.")
    
    if not_in_given:
        print(f"> Packages that are not in config:")
        for pkg in not_in_given:
            print(pkg)
    else:
        all_in_config = True

    if not_installed:
        print("\n> Packages in the config but not installed:")
        for pkg in not_installed:
            print(pkg)
    else:
        all_config_installed = True

    if all_config_installed and all_in_config:
        print(">> All packages are up to date")
    elif all_in_config:
        print("> All installed packages are in config.")
    elif all_config_installed:
        print("> All config packages are installed.")


if __name__ == "__main__":
    main()
