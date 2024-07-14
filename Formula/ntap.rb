class Ntap < Formula
  desc "Real-time network utilization monitoring tool"
  homepage "https://github.com/shellrow/ntap"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-aarch64-apple-darwin.tar.xz"
      sha256 "a27312d69f58ed99ec1823339a1d416fa21229696b9c180034ec1c198940364e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-x86_64-apple-darwin.tar.xz"
      sha256 "2cb2a279f1d86f427836a6a53110310dfe3dd8544ce0d6c44e184bb7427106e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/ntap/releases/download/v0.4.0/ntap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9e5225826b0337a641984756bab52fa956c7724aac89d526cdf56df793b79d3"
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
