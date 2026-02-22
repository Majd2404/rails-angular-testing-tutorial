#!/bin/bash
# setup-git.sh
# Run this script to initialize your git repo and push to both GitHub and GitLab

# ─── Configuration ────────────────────────────────────────────────────────────
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"
GITLAB_USERNAME="YOUR_GITLAB_USERNAME"
REPO_NAME="rails-angular-testing-tutorial"

# ─── Initialize Git ──────────────────────────────────────────────────────────
echo "📦 Initializing Git repository..."
git init
git add .
git commit -m "Initial commit: Rails/Angular Testing Tutorial (RSpec, Jest, Selenium)"

# ─── Create main branch ──────────────────────────────────────────────────────
git branch -M main

# ─── Add GitHub remote ───────────────────────────────────────────────────────
echo ""
echo "🐙 Adding GitHub remote..."
echo "First, create a new repo at: https://github.com/new"
echo "  - Name: $REPO_NAME"
echo "  - Do NOT initialize with README"
echo ""
read -p "Press Enter when GitHub repo is ready..."

git remote add github "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git push -u github main
echo "✅ Pushed to GitHub!"

# ─── Add GitLab remote ───────────────────────────────────────────────────────
echo ""
echo "🦊 Adding GitLab remote..."
echo "First, create a new project at: https://gitlab.com/projects/new"
echo "  - Name: $REPO_NAME"
echo "  - Do NOT initialize with README"
echo ""
read -p "Press Enter when GitLab project is ready..."

git remote add gitlab "https://gitlab.com/$GITLAB_USERNAME/$REPO_NAME.git"
git push -u gitlab main
echo "✅ Pushed to GitLab!"

# ─── Optional: Push to both simultaneously ───────────────────────────────────
echo ""
echo "🔀 Setting up 'origin' to push to BOTH at once..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote set-url --add --push origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote set-url --add --push origin "https://gitlab.com/$GITLAB_USERNAME/$REPO_NAME.git"

echo ""
echo "🎉 Done! Your remotes are:"
git remote -v

echo ""
echo "Now you can use:"
echo "  git push origin main   → pushes to BOTH GitHub and GitLab"
echo "  git push github main   → pushes to GitHub only"
echo "  git push gitlab main   → pushes to GitLab only"
