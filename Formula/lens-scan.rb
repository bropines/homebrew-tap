class LensScan < Formula
  desc "Google Lens OCR and translation from the command-line"
  homepage "https://github.com/bropines/chrome-lens-py"
  license "MIT"

  # The prebuilt standalone folder rather than a source build: Nuitka has
  # compiled the imports away, so it starts in about 200 ms against 500 ms from
  # source, and nothing here depends on whichever Python Homebrew happens to
  # have installed. The archives are ad-hoc signed, so Gatekeeper is content.
  on_macos do
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.2/lens_scan-macos-arm64.zip"
      sha256 "5d53b3291d62ebf28df814ab4cc195b5a88cee520737617d95787971b9b14bbc"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.2/lens_scan-macos-x86_64.zip"
      sha256 "5025b42fd070659455656a0638e72fe7b6b0528fb0e78b64c8f04751bb93d3f6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.2/lens_scan-linux-amd64.zip"
      sha256 "9c979c3ff99acfa7540f902004f7cbd0a1599755de08e80eb659fd2778e21afc"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.2/lens_scan-linux-arm64.zip"
      sha256 "aea7dd8ca1a22de6d137d234aa27bce54039368ef7aff600bb9ece818427b599"
    end
  end

  def install
    # The archive holds one folder, which Homebrew has already stepped into.
    # The whole folder has to travel together - the binary loads its extension
    # modules from beside itself - so it goes to libexec with a symlink out.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"lens_scan.bin" => "lens_scan"
  end

  def caveats
    <<~EOS
      Clipboard output (--sharex) works out of the box on macOS via pbcopy.

      To translate as well as read:
        lens_scan image.png -t en

      To avoid paying startup on every call, run it as a local daemon:
        lens_scan --serve
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lens_scan --version")
    assert_match "image_source", shell_output("#{bin}/lens_scan --help")
  end
end
