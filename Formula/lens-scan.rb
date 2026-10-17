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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.1/lens_scan-macos-arm64.zip"
      sha256 "0b3ac8e3d190e6afa9bc03bc080ba8ac096e249e985e83e18336a17d34bffcdb"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.1/lens_scan-macos-x86_64.zip"
      sha256 "3c2500c605f07c86ef5ec056635a37fabddf9e5796de96696c1b894b78b0479a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.1/lens_scan-linux-amd64.zip"
      sha256 "42f1710f31e26f814a7cabeda047ddf1d238e3bb9cc725142c3a5748125c6a3f"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.8.1/lens_scan-linux-arm64.zip"
      sha256 "4c6376acb61016878321ab86a1d52ae6248509ff90444bd1556d4302a89d7020"
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
