kind: stack
description: FSDK mutool for printer applications that explicitly opt in to the MuPDF renderer.

# Moved out of printing/base.bst to avoid shipping ~39 MiB mutool into every
# printer application. Applications that prove a job needs cfFilterMuPDFToPWG
# can depend on this element explicitly.
depends:
- freedesktop-sdk.bst:components/mutool.bst
