#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
workflow="${repo_root}/.github/workflows/oci-images.yml"

# Keep staging digest handoff pinned from the build job outputs to the manifest job.
grep -Fq 'digest_x86_64: ${{ steps.staging-digest.outputs.digest_x86_64 }}' "${workflow}"
grep -Fq 'digest_aarch64: ${{ steps.staging-digest.outputs.digest_aarch64 }}' "${workflow}"
grep -Fq '[x86_64]="${{ needs.build.outputs.digest_x86_64 }}"' "${workflow}"
grep -Fq '[aarch64]="${{ needs.build.outputs.digest_aarch64 }}"' "${workflow}"

# Keep this smoke gate downstream of the manifest job and make its two
# architecture legs use the same digest produced by that job.
grep -Fq 'publish-smoke:' "${workflow}"
grep -Fq 'needs: manifest' "${workflow}"
grep -Fq 'MANIFEST_DIGEST: ${{ needs.manifest.outputs.digest }}' "${workflow}"
grep -Fq 'tag: ${{ steps.resolve-digest.outputs.tag }}' "${workflow}"
grep -Fq 'tag_arch: x86_64' "${workflow}"
grep -Fq 'tag_arch: aarch64' "${workflow}"
grep -Fq 'podman pull --platform' "${workflow}"
grep -Fq 'podman run --rm --platform' "${workflow}"
grep -Fq 'cosign verify' "${workflow}"
grep -Fq 'oras discover "${REPO}@${MANIFEST_DIGEST}" --format json' "${workflow}"
grep -Fq 'application/vnd.spdx+json' "${workflow}"

printf '%s\n' 'OCI publish smoke contract checks passed'
