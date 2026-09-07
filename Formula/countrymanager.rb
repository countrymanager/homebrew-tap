class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.6.0/pull-strings.sh"
  sha256 "c32120bebf9e5d64807d889679f19fe26e1a7d6976c32fa06ff940711739798f"

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
