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
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.0/lens_scan-macos-arm64.zip"
      sha256 "c8008816eda37356eb816e61a7f785da540c7a91b680802201f7069ea464f625"
    end
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.0/lens_scan-macos-x86_64.zip"
      sha256 "4af2507e48dff9f3b2fdcc5113a1c7a88d6ac36d6ede5c476386ee07f8a92999"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.0/lens_scan-linux-amd64.zip"
      sha256 "16f6d4bd656b90983baa47c8c528fa172348fb52be91254ed2e7e571e67bf251"
    end
    on_arm do
      url "https://github.com/bropines/chrome-lens-py/releases/download/v4.0.0/lens_scan-linux-arm64.zip"
      sha256 "ef09d88b51fcd9d92042e296df80441affbdef7bd66df7bf8404e248c35bda45"
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
