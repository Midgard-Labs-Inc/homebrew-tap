class Aiken < Formula
  desc "Cardano smart contract language and toolchain"
  homepage "https://aiken-lang.com"
  version "1.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.2.1/aiken-aarch64-apple-darwin.tar.xz"
    sha256 "81bbd7a2ef4fa561e0ead6c315ddcd113db122d8631f2f03cc0042d670c0d177"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.2.1/aiken-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62d42621f2d1c032965ffe55c7dc78138e32991afa5a1640994b81f7a90136ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.2.1/aiken-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6fbc814ee026b08b19382ef6976ff3dff088477fb05ff5d62390757bdf602d2"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
      bin.install "aiken"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aiken"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aiken"
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
