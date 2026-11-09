#!/bin/bash
# One-time: create the public repo on the personal account, push, enable GitHub Pages.
# Later releases: copy ../sovda-blend-emulator.html to index.html, commit, and run this again (it just pushes).
set -e
cd "$(dirname "$0")"
export GH_TOKEN=$(gh auth token -u baileykwhite1)
if ! gh repo view baileykwhite1/sovda-blend-emulator >/dev/null 2>&1; then
  gh repo create baileykwhite1/sovda-blend-emulator --public --description "SOVDA Blend software emulator (Smart Line Plus HMI) for technician training"
  git remote add origin https://github.com/baileykwhite1/sovda-blend-emulator.git 2>/dev/null || true
fi
H=$(printf 'x-access-token:%s' "$GH_TOKEN" | base64)
git -c http.https://github.com/.extraheader="Authorization: basic $H" push -u origin main && echo pushed
gh api repos/baileykwhite1/sovda-blend-emulator/pages >/dev/null 2>&1 \
  || gh api -X POST repos/baileykwhite1/sovda-blend-emulator/pages -f 'source[branch]=main' -f 'source[path]=/' --jq '.html_url'
echo "https://baileykwhite1.github.io/sovda-blend-emulator/"
