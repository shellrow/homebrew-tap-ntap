class Ntap < Formula
  desc "Network traffic monitor/analyzer"
  homepage "https://github.com/shellrow/ntap"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/ntap/releases/download/v0.6.0/ntap-aarch64-apple-darwin.tar.xz"
      sha256 "e965ae1071329aee05ffcdafd6329032168329cbdade9294a33ed5d72bb85345"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.6.0/ntap-x86_64-apple-darwin.tar.xz"
      sha256 "9ba966f37e3ac6a6d20cc65169309134f044beb77ff650e639e0aec85cd7a871"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.6.0/ntap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e948476d171bb804432e41670948a18e83b0a5dbb27529ab0a0302b2eab4ca9a"
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
