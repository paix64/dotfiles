#!/bin/env python
import subprocess
from pathlib import Path
import concurrent.futures
import time


def fetch_repo(repo_path):
    try:
        result = subprocess.run(
            ["git", "fetch"],
            cwd=repo_path,
            capture_output=True,
            text=True,
            timeout=30,
        )
        return repo_path.name, result.returncode == 0
    except subprocess.TimeoutExpired:
        return repo_path.name, False
    except Exception:
        return repo_path.name, False


def check_git_repos(repo_dir):
    repos_with_changes = []
    git_repos = []

    # First find all git repos
    print("Scanning for Git repositories...")
    for item in repo_dir.iterdir():
        if item.is_dir() and (item / ".git").exists():
            git_repos.append(item)
        elif item.is_dir():
            print(f"  Skipping non-Git directory: {item.name}")

    # Parallel fetch with progress
    print(f"\nFetching latest changes for {len(git_repos)} repositories...")
    start_time = time.time()
    fetch_results = {}

    with concurrent.futures.ThreadPoolExecutor(max_workers=64) as executor:
        future_to_repo = {executor.submit(fetch_repo, repo): repo for repo in git_repos}

        for i, future in enumerate(concurrent.futures.as_completed(future_to_repo)):
            repo = future_to_repo[future]
            try:
                repo_name, success = future.result()
                fetch_results[repo_name] = success
                progress = (i + 1) / len(git_repos) * 100
                print(f"\r  Progress: {progress:.1f}% ({i+1}/{len(git_repos)})", end="")
            except Exception:
                fetch_results[repo.name] = False

    # Calculate fetch statistics
    successful_fetches = sum(fetch_results.values())
    fetch_time = time.time() - start_time
    print(
        f"\n\nFetch completed in {fetch_time:.1f}s - {successful_fetches} succeeded, {len(git_repos)-successful_fetches} failed"
    )

    # Check for changes
    print("\nChecking for uncommitted changes...")
    for repo in git_repos:
        try:
            status_result = subprocess.run(
                ["git", "status", "--porcelain"],
                cwd=repo,
                capture_output=True,
                text=True,
            )

            if status_result.stdout.strip():
                colored_result = subprocess.run(
                    ["git", "-c", "color.ui=always", "status", "--short"],
                    cwd=repo,
                    capture_output=True,
                    text=True,
                )
                repos_with_changes.append(
                    {
                        "name": repo.name,
                        "changes": colored_result.stdout,
                        "fetch_success": fetch_results[repo.name],
                    }
                )
        except Exception as e:
            print(f"Error checking repository {repo.name}: {e}")

    return repos_with_changes


def main():
    repo_dir = Path.home() / "Repositories"

    if not repo_dir.exists():
        print(f"Error: Directory '{repo_dir}' does not exist.")
        exit(-1)

    repos = check_git_repos(repo_dir)

    if repos:
        print("\nRepositories with uncommitted changes:")
        for repo in repos:
            fetch_status = "✓" if repo["fetch_success"] else "✗"
            print(f"\nRepository: {repo['name']} [Fetch: {fetch_status}]")
            print("Changes:")
            print(repo["changes"])
    else:
        print("\nNo repositories with uncommitted changes found.")


if __name__ == "__main__":
    main()
