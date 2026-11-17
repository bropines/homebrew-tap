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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.1/lens_scan-macos-arm64.zip"
      sha256 "db0736d0323b77d5cbdab9b7a27eab04590b81f34a008c2c9c5d7305bde6486a"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.1/lens_scan-macos-x86_64.zip"
      sha256 "f956eb5f3a2a67b8c5c16909e01fe34ff8381c3cb6be219cd05bd3af0face530"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.1/lens_scan-linux-amd64.zip"
      sha256 "3c054ab6f1cec7d48a6f5ad76e661b0aa48aef91f0bdf68dd0685fc0a0fdd31c"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.1/lens_scan-linux-arm64.zip"
      sha256 "1e3df37372077930a5ddbc34c94ef46e14cef2bd9d767bacf55191d7a78c5f92"
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
