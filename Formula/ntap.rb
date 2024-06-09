class Ntap < Formula
  desc "Real-time network utilization monitoring tool"
  homepage "https://github.com/shellrow/ntap"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/ntap/releases/download/v0.2.0/ntap-aarch64-apple-darwin.tar.xz"
      sha256 "82f3198836f5a30a4a677237b26225fb80b619edfaa35f3c1ff1271cea3c2b9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.2.0/ntap-x86_64-apple-darwin.tar.xz"
      sha256 "bf3ebd72ffb47da6a7e7f53ada3cc33247c779b7ac81eec2ccaaaac34f535c05"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.2.0/ntap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5c8cb145cf66340153bcaebf5bea3120feb64907e409a97c98b8730f073f345"
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
