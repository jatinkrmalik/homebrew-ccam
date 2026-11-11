class Ccam < Formula
  desc "Switch between multiple Claude Code accounts on one machine"
  homepage "https://github.com/jatinkrmalik/ccam"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.5.0/ccam-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "da255ca905dcc2af7a34dfe4c332f059be30777ab9109f945b288b5354a332f9"
    end
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.5.0/ccam-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "714b8fc2c5703deaa1250b1cdae8e381c5b40e0af66c0d927ade7522ec04d4e7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jatinkrmalik/ccam/releases/download/v0.5.0/ccam-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fcdcb1f5023949278e9c539b61d6ef722bc4da0068ba7b3d193d8e9296a514c4"
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
