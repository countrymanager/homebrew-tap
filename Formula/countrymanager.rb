class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.3.0/pull-strings.sh"
  sha256 "6bc8b3418ce42c6d2207eea7808ad47a63edf44f8d2437870574110bc6b2972a"

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
