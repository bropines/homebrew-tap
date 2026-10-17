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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.0/lens_scan-macos-arm64.zip"
      sha256 "caac3926bd3fbd527df1b10618e1e1ea9fe23371f82c2154089e3c771ecb37af"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.0/lens_scan-macos-x86_64.zip"
      sha256 "a2de5138ef9ab4f05748e1946c70fb733334fd3e8c67dd3d467759662ffda473"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.0/lens_scan-linux-amd64.zip"
      sha256 "1d0da3b63f5844e9dbbbe075e8b0dc17ade16f0113ac115af0a12b00afe3ad7c"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.0/lens_scan-linux-arm64.zip"
      sha256 "900f0330b4ccc3612eef38daaff735ddb468de67975802402cc9f8b942ab4e08"
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
