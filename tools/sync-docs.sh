#!/usr/bin/env bash
# Copy the root README and each module README into docs/ for Backstage TechDocs.
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf docs/modules && mkdir -p docs/modules
cp README.md docs/index.md
for f in modules/*/README.md; do
  cp "$f" "docs/modules/$(basename "$(dirname "$f")").md"
done
{
  echo "site_name: mTerraform"
  echo "docs_dir: docs"
  echo "plugins:"
  echo "  - techdocs-core"
  echo "nav:"
  echo "  - Home: index.md"
  echo "  - Modules:"
  for f in docs/modules/*.md; do
    n=$(basename "$f" .md); echo "      - $n: modules/$n.md"
  done
} > mkdocs.yml
