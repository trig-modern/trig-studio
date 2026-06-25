#!/usr/bin/env bash
# Trig Studio one-command deploy.  Usage:  bash deploy.sh "what changed"
set -e
cd "$(dirname "$0")"
rm -f .git/index.lock                       # clear any stale lock
echo "→ staging changes…"
git add -A
git commit -m "${1:-Update Trig Studio}" || echo "(nothing new to commit)"
echo "→ syncing with origin (rebase, never force)…"
git pull --rebase --autostash origin main
echo "→ pushing…"
git push origin main
echo "✅ Pushed. Netlify auto-publishes in ~10s → https://dreamy-kelpie-9dcdd2.netlify.app/"
