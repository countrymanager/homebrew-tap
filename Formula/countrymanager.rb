class Countrymanager < Formula
  desc "Pull and manage CountryManager localization files from the shell"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.7.0/pull-strings.sh"
  sha256 "b3be1183dd1663d9044e5031fbcf172872e919670024905c0e425f22db3c7033"

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
