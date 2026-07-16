# ============================================================================
# TEMPLATE FILE - Do not edit the generated formula!
# ============================================================================
#
# This is the SOURCE TEMPLATE for the Homebrew formula.
# Location: cerby-engineering/hostman/homebrew/hostman.rb.template
#
# This repo is its own Homebrew tap. The GENERATED formula lives at:
#   cerby-engineering/hostman/Formula/hostman.rb
#
# DO NOT edit the generated formula directly - your changes will be
# overwritten on the next release. Edit THIS template instead.
#
# How it works:
#   1. When hostman releases, the CI workflow renders this template
#   2. Variables like 0.1.4+db4310c, 0.1.4-db4310c, etc. are substituted (envsubst)
#   3. The result is committed to Formula/hostman.rb on main
#
# Variables available for substitution:
#   0.1.4+db4310c    - Semver version (e.g., 0.1.6+abc1234)
#   0.1.4-db4310c        - Release tag suffix (e.g., 0.1.6-abc1234)
#   fec5d00f7786f0d31ca25d0bd9bcb95c8c3bc57b1ef80bad213ef9cceeee669d  - SHA256 of the arm64 tarball
#   9808f12acbf3d9bd50dfbfa9d631a170ead281a3f8bf26cf62fb2d86fe26e961 - SHA256 of the x86_64 tarball
#
# ============================================================================

class Hostman < Formula
  desc "Manage bracketed blocks of entries in /etc/hosts"
  homepage "https://github.com/cerby-engineering/hostman"
  license "MIT"
  version "0.1.4+db4310c"

  on_macos do
    on_arm do
      url "https://github.com/cerby-engineering/hostman/releases/download/v0.1.4-db4310c/hostman-darwin-arm64-v0.1.4-db4310c.tar.gz"
      sha256 "fec5d00f7786f0d31ca25d0bd9bcb95c8c3bc57b1ef80bad213ef9cceeee669d"
    end
    on_intel do
      url "https://github.com/cerby-engineering/hostman/releases/download/v0.1.4-db4310c/hostman-darwin-x86_64-v0.1.4-db4310c.tar.gz"
      sha256 "9808f12acbf3d9bd50dfbfa9d631a170ead281a3f8bf26cf62fb2d86fe26e961"
    end
  end

  def install
    bin.install "hostman"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostman --version 2>&1", 0)
  end
end
