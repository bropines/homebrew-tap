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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.2/lens_scan-macos-arm64.zip"
      sha256 "c5c8d683bbb1646f42a32e8b1818e6e16752ef496e180cda0c57617b2f7eef7b"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.2/lens_scan-macos-x86_64.zip"
      sha256 "a31ba1ebe051d3fe24c4adc14a560b738c7f4d83d2debbb250041b17c06707fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.2/lens_scan-linux-amd64.zip"
      sha256 "917bdb5de29807695152a1df3dda419749d1b7f4e16416f872cb3e3d17a9a764"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.2/lens_scan-linux-arm64.zip"
      sha256 "5cf347b06ae8006ddcf41f435237a6d755ab6732d27472404dce77492add5af6"
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
    # The machine-readable form, which outlives any rewording of the help.
    assert_match "\"version\": \"#{version}\"", shell_output("#{bin}/lens_scan version --json")
    # Routed before anything touches the network, so it works in a sandbox.
    assert_match "Commands:", shell_output("#{bin}/lens_scan --help")
    # A wrong command line is EX_USAGE (64), not a crash or a failed scan.
    shell_output("#{bin}/lens_scan --no-such-flag 2>&1", 64)
  end
end
