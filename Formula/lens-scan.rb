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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.0/lens_scan-macos-arm64.zip"
      sha256 "718c5c9814f9b2b9b8a395305ea285a9435130b8b21b9fc3a3bb11cee15825b4"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.0/lens_scan-macos-x86_64.zip"
      sha256 "1a28500a4db7a4e15d700c0c5b8232f58a3bf42c23df42dad9bb12ff268572fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.0/lens_scan-linux-amd64.zip"
      sha256 "8623b5a1d0164a0fab1cbf4662b8591c958225b0009e0bce2dec2b7b2a4453f7"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.0/lens_scan-linux-arm64.zip"
      sha256 "b2e4f6ada3c841ea182707c9cdd1c8cb3ae6369207b34a5f5ffff08700d333b2"
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
