# ============================================================================
# TEMPLATE FILE - Do not edit the generated formula!
# ============================================================================
#
# This is the SOURCE TEMPLATE for the Homebrew formula.
# Location: cerby-engineering/host-man/homebrew/host-man.rb.template
#
# This repo is its own Homebrew tap. The GENERATED formula lives at:
#   cerby-engineering/host-man/Formula/host-man.rb
#
# DO NOT edit the generated formula directly - your changes will be
# overwritten on the next release. Edit THIS template instead.
#
# How it works:
#   1. When host-man releases, the CI workflow renders this template
#   2. Variables like 0.1.2+20447a3, 0.1.2-20447a3, etc. are substituted (envsubst)
#   3. The result is committed to Formula/host-man.rb on main
#
# Variables available for substitution:
#   0.1.2+20447a3    - Semver version (e.g., 0.1.6+abc1234)
#   0.1.2-20447a3        - Release tag suffix (e.g., 0.1.6-abc1234)
#   7d8421ed252ed15be88e21ac8fc1e37bebd0d4d07ef5a126d5d8ada6d2e0fc44  - SHA256 of the arm64 tarball
#   8aad074b409112a58a693e84a93f40f9d66b8d48dd4bfc8fe74d2b036c36d183 - SHA256 of the x86_64 tarball
#
# ============================================================================

class HostMan < Formula
  desc "Manage bracketed blocks of entries in /etc/hosts"
  homepage "https://github.com/cerby-engineering/host-man"
  license "MIT"
  version "0.1.2+20447a3"

  on_macos do
    on_arm do
      url "https://github.com/cerby-engineering/host-man/releases/download/v0.1.2-20447a3/host-man-darwin-arm64-v0.1.2-20447a3.tar.gz"
      sha256 "7d8421ed252ed15be88e21ac8fc1e37bebd0d4d07ef5a126d5d8ada6d2e0fc44"
    end
    on_intel do
      url "https://github.com/cerby-engineering/host-man/releases/download/v0.1.2-20447a3/host-man-darwin-x86_64-v0.1.2-20447a3.tar.gz"
      sha256 "8aad074b409112a58a693e84a93f40f9d66b8d48dd4bfc8fe74d2b036c36d183"
    end
  end

  def install
    bin.install "hostman"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostman --version 2>&1", 0)
  end
end
