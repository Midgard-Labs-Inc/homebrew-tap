class Aiken < Formula
  desc "Cardano smart contract language and toolchain"
  homepage "https://aiken-lang.com"
  version "1.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.3.0/aiken-aarch64-apple-darwin.tar.xz"
    sha256 "38278661cdd18ec8608c44112c091dc69e26392aab031062c7626f6fd546ede1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.3.0/aiken-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9bf977877cb8836fb3df01eeebced5a8bde9548368dac866df405229c8e1329d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Midgard-Labs-Inc/aiken/releases/download/v1.3.0/aiken-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e621ba361fe5664cebc53970959dedec9412b06507a2bf34b4029a65c5cea055"
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
