class Ntap < Formula
  desc "Real-time network utilization monitoring tool"
  homepage "https://github.com/shellrow/ntap"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-aarch64-apple-darwin.tar.xz"
      sha256 "f03f63fb450fa62c8e0eb7cc292c29cff17a822d4174a7d6f8106bca6d2512a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-x86_64-apple-darwin.tar.xz"
      sha256 "a962cd30bf204123a5a240d39fe987447d10fc0890c79e707fe5c35fcefe26fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9e76b19a6487d44992b7a201e5296f453475fed1eb5ccfc7308a38fafb342e7"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ntap"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ntap"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ntap"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
