class Countrymanager < Formula
  desc "Pull and manage CountryManager localization files from the shell"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.9.0/pull-strings.sh"
  sha256 "10f4fc6b4933e0326413f960a98ab49d3b72d686f9127f396c82cb7978d135b2"

  def install
    bin.install "pull-strings.sh" => "countrymanager"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/countrymanager 2>&1", 1)
    # Pin the formula's own version against the script it installed: without
    # this, a stale `url`/`sha256` that was never bumped after a script change
    # still passes CI, which is exactly how the two install channels drift.
    assert_equal "countrymanager #{version}",
                 shell_output("#{bin}/countrymanager --version").strip
  end
end
