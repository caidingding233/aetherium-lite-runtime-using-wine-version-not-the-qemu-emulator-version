# Aetherium Lite Runtime (Wine Version)

This repository tracks the Wine/Proton runtime source recipe for Aetherium Lite.
It is not the QEMU emulator version.

It intentionally does not vendor full upstream source checkouts or generated
runtime binaries in git history. Instead, it stores:

- pinned upstream source manifest
- HarmonyOS runtime glue files
- Box64/Wine source patches used by the current prototype
- scripts for fetching and auditing upstream sources
- copied upstream license texts for the currently referenced components

## What Runs In-process

Aetherium Lite loads key runtime pieces as HarmonyOS native shared objects:

```text
entry HAP
  -> proton HSP
      -> libproton.so NAPI bridge
      -> libproton_hmos_runtime.so
      -> libbox64_hmos.so
      -> libbox64_hmos_core.so
      -> libwine_hmos_server.so when native wineserver is enabled
      -> staged Proton/Wine payload
```

That architecture is why this repository is mixed-license. The app shell can be
MIT, but Wine/vkd3d-proton runtime modifications remain LGPL-covered.

## Fetch The Upstream Sources

```bash
git clone https://github.com/caidingding233/aetherium-lite-runtime-using-wine-version-not-the-qemu-emulator-version.git
cd aetherium-lite-runtime-using-wine-version-not-the-qemu-emulator-version
scripts/proton-runtime/bootstrap_runtime_sources.sh
```

The bootstrap helper checks out the verified commits recorded in
`third_party/proton-runtime/manifest.json`, applies the Aetherium source
patches, verifies the HMOS in-process source files, and audits top-level
license files.

To fetch upstream sources without applying Aetherium patches:

```bash
scripts/proton-runtime/fetch_sources.sh
```

To follow upstream branch heads instead of the verified commits:

```bash
PROTON_RUNTIME_PINNED=0 scripts/proton-runtime/bootstrap_runtime_sources.sh
```

To fetch Proton submodules as well:

```bash
PROTON_RUNTIME_FETCH_SUBMODULES=1 scripts/proton-runtime/bootstrap_runtime_sources.sh
```

If WSL needs the Windows host proxy:

```bash
PROTON_RUNTIME_PROXY=http://172.21.16.1:7897 scripts/proton-runtime/bootstrap_runtime_sources.sh
```

## Apply The Current Source Patches

For corresponding-source reconstruction of the current prototype:

```bash
scripts/proton-runtime/apply_corresponding_source_patches.sh
```

The script applies the patches in `third_party/proton-runtime/source-patches/`.
Those patches are generated from the local modified source trees used by this
prototype. DXVK and vkd3d-proton currently have no local source diff in this
snapshot; they are tracked by pinned upstream commit plus license metadata.

The older `scripts/proton-runtime/apply_hmos_patches.sh` is kept for the
incremental Box64 compatibility patches used by the app-side build workflow.

Two files often look "missing" before bootstrap:

- `third_party/proton-runtime/src/box64/src/wrapped/wrappedlibc.c` comes from
  the upstream Box64 checkout.
- `third_party/proton-runtime/src/box64/src/hmos_inprocess.c` is created by the
  Aetherium Box64 source patch.

Run this if the upstream checkout exists but the HMOS patch result is missing:

```bash
scripts/proton-runtime/ensure_runtime_sources.sh box64
```

## Audit License Files

```bash
scripts/proton-runtime/audit_licenses.sh
```

Expected top-level license files include:

- Proton: `LICENSE`, `LICENSE.proton`, `dist.LICENSE`
- Box64: `LICENSE`
- Wine: `LICENSE`, `COPYING.LIB`, `AUTHORS`
- DXVK: `LICENSE`
- vkd3d-proton: `LICENSE`, `COPYING`, `AUTHORS`

## Release Policy

Do not publish generated runtime binaries from git commits. Use GitHub Releases
or another artifact channel for HSP/runtime payloads, and attach:

- exact source manifest
- corresponding source patches
- license and notice bundle
- checksums for binary artifacts
