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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.1/lens_scan-macos-arm64.zip"
      sha256 "c6106cf0614f67ebbdbf3fbb2d41013a27af172be8637babdefb8c0af0ed3025"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.1/lens_scan-macos-x86_64.zip"
      sha256 "3b0c596198e8e35679c8b06c6860135727b71f4ad51c143441fe63eef0f15653"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.1/lens_scan-linux-amd64.zip"
      sha256 "4816354a6838499b9645b8155c6051616839b2230ea90fedcb322c7a443d9402"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v3.7.1/lens_scan-linux-arm64.zip"
      sha256 "a852cf4584f9d0fb5d996567dfa2d208de89d634f3b2262f655abb61cc7be391"
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
