import subprocess

def get_installed_packages():
    try:
        # Run pacman -Qe command to get the list of explicitly installed packages
        result = subprocess.run(['pacman', '-Qe'], stdout=subprocess.PIPE, text=True, check=True)
        # Split the result into lines and extract the package names
        installed_packages = [line.split()[0] for line in result.stdout.splitlines()]
        return installed_packages
    except subprocess.CalledProcessError as e:
        print(f"Error executing pacman -Qe: {e}")
        return []

def read_given_packages(file_path):
    try:
        with open(file_path, 'r') as file:
            # Read the file and split lines to get the list of package names
            given_packages = [line.split()[0].strip() for line in file if line.strip()]
        return given_packages
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return []

def compare_packages(installed_packages, given_packages):
    installed_set = set(installed_packages)
    given_set = set(given_packages)
    
    # Packages that are installed but not in the given list
    not_in_given = installed_set - given_set
    # Packages that are in the given list but not installed
    not_installed = given_set - installed_set
    
    return not_in_given, not_installed

def main():
    # Path to the file containing the list of given packages
    given_packages_file = 'packages.conf'  # Replace with the actual path to your file
    
    # Read the given packages from the file
    given_packages = read_given_packages(given_packages_file)
    
    if not given_packages:
        print("No given packages found or error reading the given packages file.")
        return
    
    # Get the list of installed packages
    installed_packages = get_installed_packages()
    
    if not installed_packages:
        print("No installed packages found or error retrieving installed packages.")
        return
    
    # Compare the installed packages with the given list
    not_in_given, not_installed = compare_packages(installed_packages, given_packages)
    
    if not_in_given:
        print("Packages installed but not in the given list:")
        for pkg in not_in_given:
            print(pkg)
    else:
        print("All installed packages are in the given list.")
    
    if not_installed:
        print("\nPackages in the given list but not installed:")
        for pkg in not_installed:
            print(pkg)
    else:
        print("All given packages are installed.")

if __name__ == "__main__":
    main()

