# Third-Party Notices

This repository is a source recipe and corresponding-source support repository
for the Aetherium Lite Wine runtime.

| Component | Source | License family | Current local diff |
| --- | --- | --- | --- |
| Proton | https://github.com/ValveSoftware/Proton.git | BSD-style top-level plus bundled third-party licenses | none in this snapshot |
| Box64 | https://github.com/ptitSeb/box64.git | MIT | yes, under `source-patches/box64` |
| Wine | https://github.com/wine-mirror/wine.git | LGPL-2.1-or-later | yes, under `source-patches/wine` |
| DXVK | https://github.com/doitsujin/dxvk.git | zlib/libpng style | none in this snapshot |
| vkd3d-proton | https://github.com/HansKristian-Work/vkd3d-proton.git | LGPL-2.1 | none in this snapshot |

Binary distributions made from this repository must include notices for the
actual final payload. Proton redists can include many more components than the
five top-level repositories listed here, including fonts, wine-mono/gecko,
GStreamer-related pieces, OpenVR, FAudio, and other libraries.

For LGPL-covered components, publish corresponding source, patches, and rebuild
instructions for the exact binary release.
