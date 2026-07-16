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
#   2. Variables like 0.1.3+1f321e0, 0.1.3-1f321e0, etc. are substituted (envsubst)
#   3. The result is committed to Formula/host-man.rb on main
#
# Variables available for substitution:
#   0.1.3+1f321e0    - Semver version (e.g., 0.1.6+abc1234)
#   0.1.3-1f321e0        - Release tag suffix (e.g., 0.1.6-abc1234)
#   40cf039a54b8ef3f861da44949b2f87a283de320549da8058c043444f24f3085  - SHA256 of the arm64 tarball
#   e364d8ddfb4ee603f39031430f002193365531c58d0c54808e36ee3148b02fb6 - SHA256 of the x86_64 tarball
#
# ============================================================================

class HostMan < Formula
  desc "Manage bracketed blocks of entries in /etc/hosts"
  homepage "https://github.com/cerby-engineering/host-man"
  license "MIT"
  version "0.1.3+1f321e0"

  on_macos do
    on_arm do
      url "https://github.com/cerby-engineering/host-man/releases/download/v0.1.3-1f321e0/host-man-darwin-arm64-v0.1.3-1f321e0.tar.gz"
      sha256 "40cf039a54b8ef3f861da44949b2f87a283de320549da8058c043444f24f3085"
    end
    on_intel do
      url "https://github.com/cerby-engineering/host-man/releases/download/v0.1.3-1f321e0/host-man-darwin-x86_64-v0.1.3-1f321e0.tar.gz"
      sha256 "e364d8ddfb4ee603f39031430f002193365531c58d0c54808e36ee3148b02fb6"
    end
  end

  def install
    bin.install "hostman"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostman --version 2>&1", 0)
  end
end
