class Aiken < Formula
  desc "Cardano smart contract language and toolchain"
  homepage "https://aiken-lang.com"
  version "1.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.4.0/aiken-aarch64-apple-darwin.tar.xz"
    sha256 "065877356142d5b20fc870fc064d895160623dd5aa50046c2ffc091fb057a3f6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.4.0/aiken-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9d5b7bf80d0110dab2601c57cb564c1a21309bb0ba9be54039503131bc00b9fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.4.0/aiken-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82b1b69d1ec09bfd6a384cad639ce38a15d38913cbaa6704bb6e833987e8ec31"
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
