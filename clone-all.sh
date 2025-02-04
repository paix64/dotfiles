gh repo list --limit 999 | while read -r repo _; do
  # Extract the second word after splitting by '/'
  repo_name=$(echo "$repo" | cut -d'/' -f2)
  mkdir -p ~/Repositories
  gh repo clone "$repo" ~/Repositories/$repo_name
done

