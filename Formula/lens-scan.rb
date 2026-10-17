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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.6.0/lens_scan-macos-arm64.zip"
      sha256 "f4c46517762a1a86f0765ec7ac549cae50df7ff087fbf326bdf2c53d9376b398"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.6.0/lens_scan-macos-x86_64.zip"
      sha256 "6e0e7bb5efc62e319ab70d466f980b9cae9fd6b71bae5c0d8e6ce7270b6d09bc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.6.0/lens_scan-linux-amd64.zip"
      sha256 "08a2ce99e35bdf5f6fc92d0c6b741ac17e7c34cddfe5b3ce06eee176f7e54e79"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.6.0/lens_scan-linux-arm64.zip"
      sha256 "b23383626238c7815a1d053e8ed519e6b1f6f2bbd72de91bba2530f73b53cda6"
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
