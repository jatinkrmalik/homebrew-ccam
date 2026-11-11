#!/usr/bin/env bash
# Rewrites Formula/ccam.rb for the latest ccam release. Does nothing when the
# formula is already current or the release's archives are not uploaded yet.
# Set FORCE=1 to regenerate even when the version has not changed.
set -euo pipefail

repo="jatinkrmalik/ccam"
formula="Formula/ccam.rb"

url=$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest")
tag=${url##*/}
case "$tag" in
  v[0-9]*) ;;
  *) echo "could not find the latest release (got '$tag')" >&2; exit 1 ;;
esac
version=${tag#v}

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")
if [ "$version" = "$current" ] && [ -z "${FORCE:-}" ]; then
  echo "Formula is already at $version"
  exit 0
fi

base="https://github.com/$repo/releases/download/$tag"
checksum() {
  local sum
  sum=$(curl -fsSL "$base/ccam-$tag-$1.tar.gz.sha256" 2>/dev/null | awk '{print $1}') || true
  if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'; then
    echo "Archive for $1 is not available yet; will try again later" >&2
    return 1
  fi
  printf '%s' "$sum"
}

arm=$(checksum aarch64-apple-darwin) || exit 0
intel=$(checksum x86_64-apple-darwin) || exit 0
linux=$(checksum x86_64-unknown-linux-musl) || exit 0

cat > "$formula" <<FORMULA
class Ccam < Formula
  desc "Switch between multiple Claude Code accounts on one machine"
  homepage "https://github.com/$repo"
  version "$version"
  license "MIT"

  on_macos do
    on_arm do
      url "$base/ccam-$tag-aarch64-apple-darwin.tar.gz"
      sha256 "$arm"
    end
    on_intel do
      url "$base/ccam-$tag-x86_64-apple-darwin.tar.gz"
      sha256 "$intel"
    end
  end

  on_linux do
    on_intel do
      url "$base/ccam-$tag-x86_64-unknown-linux-musl.tar.gz"
      sha256 "$linux"
    end
  end

  def install
    bin.install "ccam"
  end

  def caveats
    <<~EOS
      Finish the install with:
        ccam setup
      It puts a \`claude\` shim in ~/.ccam/bin and prints the PATH line to add.
      Run it again after \`brew upgrade ccam\`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccam --version")
  end
end
FORMULA

echo "Formula updated from ${current:-none} to $version"
