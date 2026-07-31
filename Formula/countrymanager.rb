class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.0.2/pull-strings.sh"
  sha256 "9f09467bde980e5d64db85d97306ab2edf1d1b03aea5f817d96c5ef3a4f32d07"

  def install
    bin.install "pull-strings.sh" => "countrymanager"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/countrymanager 2>&1", 1)
  end
end
