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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.5.2/lens_scan-macos-arm64.zip"
      sha256 "66cb73b2aa6e2d6b6c9c2e58e5638453fdda6e447cb9f516df4d37aa554e18ab"
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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.5.2/lens_scan-linux-amd64.zip"
      sha256 "ae587997a8b008089de6452e91bd1996992fc38ddab16b4afe79a663461abac1"
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
