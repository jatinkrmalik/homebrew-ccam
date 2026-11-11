class Ccam < Formula
  desc "Switch between multiple Claude Code accounts on one machine"
  homepage "https://github.com/jatinkrmalik/ccam"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.1/ccam-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "9ffce7dbe2bd17982bae15f03393bf52b2eb0158726831235aba69b9650b3a40"
    end
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.1/ccam-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "4255204f3aca54a5077bc3e18c01f586af5e444e29ff57f8677a5ca445f5f7e9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.1/ccam-v0.4.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a9f780eba8a0067395f81baf76cf297c07ecf50a9f0a098a2769312f773cc4cb"
    end
  end

  def install
    bin.install "ccam"
  end

  def caveats
    <<~EOS
      Finish the install with:
        ccam setup
      It puts a `claude` shim in ~/.ccam/bin and prints the PATH line to add.
      Run it again after `brew upgrade ccam`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccam --version")
  end
end
