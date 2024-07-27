class Ntap < Formula
  desc "Network traffic monitor/analyzer"
  homepage "https://github.com/shellrow/ntap"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/ntap/releases/download/v0.5.0/ntap-aarch64-apple-darwin.tar.xz"
      sha256 "5c38a02e1251e2b42d11afbf8645b197c5cbe390962cfeaf8787fee0605c50b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.5.0/ntap-x86_64-apple-darwin.tar.xz"
      sha256 "659b31d737e5812e5b9d7e629b446a4ddf7897949f5e40e5d28538b438d2944d"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.5.0/ntap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46be6eba03d7ecc8dc85643fb987fa2494435b782bcd7ba7068c5932b3c1c85f"
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
