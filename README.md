# bropines/homebrew-tap

Homebrew formulae for [chrome-lens-py](https://github.com/bropines/chrome-lens-py).

```bash
brew install bropines/tap/lens-scan
```

That is all one command — `brew` taps this repository on the way past.

## What it installs

`lens_scan`, a command-line front end to Google Lens: OCR, translation, and
rendering the translation back onto the image the way Chromium's Lens overlay
does it.

```bash
lens_scan shot.png                 # read the text
lens_scan shot.png -t en           # translate it
lens_scan page.png -t en -to out.png --manga
lens_scan --serve                  # run as a local daemon
lens_scan --version                # which copy am I running?
```

## Which build this is

The prebuilt standalone folder from the project's releases, not a source build.
It starts in roughly 200 ms rather than 500 ms, because Nuitka has compiled the
imports away, and it does not care which Python you have. The archives are
ad-hoc signed, so Gatekeeper lets them run.

Published builds cover **Apple Silicon** and **x86_64 Linux**. On Intel Macs or
ARM Linux the formula stops and points you at uv instead:

```bash
uv tool install "chrome-lens-py[clipboard]"
```

## Other ways in

Homebrew is one of four; none of them needs Python already installed except
pip:

| | one-liner |
|---|---|
| uv | `curl -fsSL https://raw.githubusercontent.com/bropines/chrome-lens-py/main/scripts/install-uv.sh \| sh` |
| standalone zip | `curl -fsSL https://raw.githubusercontent.com/bropines/chrome-lens-py/main/scripts/install.sh \| sh` |
| pip | `pip install chrome-lens-py` |

## Updating

The formula is bumped automatically when a new version is tagged in the main
repository, so `brew upgrade` is enough.
