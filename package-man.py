#!/usr/bin/env python3

import subprocess
import argparse
import sys

failed_packages = []
new_packages = []


def get_dependencies(package):
    try:
        if package.startswith("#"):
            return []
        cmd = ["pactree", "-u", package]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return [line.strip() for line in result.stdout.split("\n") if line.strip()]
    except subprocess.CalledProcessError:
        print(f"Error: Failed to get dependencies for {package}")
        failed_packages.append(package)
        return []
    except FileNotFoundError:
        print("Error: pactree not found. Please install pacman-contrib package.")
        sys.exit(1)


def get_installed_packages():
    try:
        cmd = ["pacman", "-Qeq"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return [line.strip() for line in result.stdout.split("\n") if line.strip()]
    except subprocess.CalledProcessError:
        print("Error: Failed to get installed packages.")
        sys.exit(1)
    except FileNotFoundError:
        print("Error: pacman not found. Please install pacman package.")
        sys.exit(1)


def count_dependencies(package_file):
    try:
        with open(package_file, "r") as file:
            packages = [line.strip() for line in file if line.strip()]
    except FileNotFoundError:
        print(f"Error: File '{package_file}' not found.")
        sys.exit(1)

    # Collect all dependencies, removing duplicates
    all_dependencies = set()
    for package in packages:
        print(f"Analyzing {package}...")
        deps = get_dependencies(package)
        all_dependencies.update(deps)

    print(f"\nTotal unique package count: {len(all_dependencies)}")

    # Print failed packages
    if failed_packages:
        print(f"\nNot installed packages ({len(failed_packages)}):")
        for package in failed_packages:
            print(f"- {package}")

    installed_packages = get_installed_packages()
    new_packages = [pkg for pkg in installed_packages if pkg not in packages]
    if new_packages:
        print(f"\nNew packages installed ({len(new_packages)}):")
        for package in new_packages:
            print(f"- {package}")


def main():
    parser = argparse.ArgumentParser(description="Arch Package Dependency Manager")
    parser.add_argument("packages", nargs="*", help="Package names to analyze")
    parser.add_argument(
        "-c",
        "--count",
        metavar="FILE",
        help="Count dependencies for packages listed in FILE",
    )

    args = parser.parse_args()

    if args.count:
        count_dependencies(args.count)
    elif args.packages:
        unique_deps = set()
        for package in args.packages:
            deps = get_dependencies(package)
            unique_deps.update(set(deps))
        for i, dep in enumerate(unique_deps, 1):
            print(f"{i}. {dep}")
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
