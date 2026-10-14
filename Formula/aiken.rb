class Aiken < Formula
  desc "Cardano smart contract language and toolchain"
  homepage "https://github.com/aiken-lang/aiken"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aiken-lang/aiken/releases/download/v1.2.0/aiken-aarch64-apple-darwin.tar.xz"
    sha256 "f50b073f05e59b73ba3f1876dc22fb32cb0218497ab8af4a75e73cb232e7567b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aiken-lang/aiken/releases/download/v1.2.0/aiken-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61cad3d8e01cf718fbe6da1fed95ff53950210166d066e04babd5272ebdbcfdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aiken-lang/aiken/releases/download/v1.2.0/aiken-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b94ca60f71e2421fa9b9f8ffd3b6b5d7c528c4a122d58378055b71a28070717"
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
