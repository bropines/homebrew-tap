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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.5.1/lens_scan-macos-arm64.zip"
      sha256 "3fb3f9becdb24071db21ae079b6dc466ae522cdd111b4743238ad0c6d5a41e7c"
    end

    on_intel do
      odie <<~MSG
        No Intel build is published yet - only Apple Silicon.
        Install it with uv instead:
          uv tool install "chrome-lens-py[clipboard]"
      MSG
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.5.1/lens_scan-linux-amd64.zip"
      sha256 "eea7b039a98a68c03e4d76dd19c62240a33907893d8a846589c7c908ace3109b"
    end

    on_arm do
      odie <<~MSG
        No ARM Linux build is published yet.
        Install it with uv instead:
          uv tool install "chrome-lens-py[clipboard]"
      MSG
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
