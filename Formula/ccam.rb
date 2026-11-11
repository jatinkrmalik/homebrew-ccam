class Ccam < Formula
  desc "Switch between multiple Claude Code accounts on one machine"
  homepage "https://github.com/jatinkrmalik/ccam"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.0/ccam-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "53bf84f3fa6b294b5aa45ae010057b45578d9ea73db7bd4e5077a4cc41dac2ab"
    end
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.0/ccam-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "11119de97d4ec76a13255d6fd4d1c4f1c134ea909b34129cf53f05911acef952"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.4.0/ccam-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3564d1d998cb233778fe16d06800b0d08170b86e2a30e8b230c7f7988cfe5d21"
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
