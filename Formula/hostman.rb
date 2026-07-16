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
#   2. Variables like 0.1.5+dfc60de, 0.1.5-dfc60de, etc. are substituted (envsubst)
#   3. The result is committed to Formula/hostman.rb on main
#
# Variables available for substitution:
#   0.1.5+dfc60de    - Semver version (e.g., 0.1.6+abc1234)
#   0.1.5-dfc60de        - Release tag suffix (e.g., 0.1.6-abc1234)
#   2dd5a8041cb13cc5a81c5f9b13000903abe19d455fb1da0d4b303111fedf5c6f  - SHA256 of the arm64 tarball
#   810fe444a48f624f2c9af8c558fd981ed77b783ef09d0943a12acb61e53f03a2 - SHA256 of the x86_64 tarball
#
# ============================================================================

class Hostman < Formula
  desc "Manage bracketed blocks of entries in /etc/hosts"
  homepage "https://github.com/cerby-engineering/hostman"
  license "MIT"
  version "0.1.5+dfc60de"

  on_macos do
    on_arm do
      url "https://github.com/cerby-engineering/hostman/releases/download/v0.1.5-dfc60de/hostman-darwin-arm64-v0.1.5-dfc60de.tar.gz"
      sha256 "2dd5a8041cb13cc5a81c5f9b13000903abe19d455fb1da0d4b303111fedf5c6f"
    end
    on_intel do
      url "https://github.com/cerby-engineering/hostman/releases/download/v0.1.5-dfc60de/hostman-darwin-x86_64-v0.1.5-dfc60de.tar.gz"
      sha256 "810fe444a48f624f2c9af8c558fd981ed77b783ef09d0943a12acb61e53f03a2"
    end
  end

  def install
    bin.install "hostman"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostman --version 2>&1", 0)
  end
end
