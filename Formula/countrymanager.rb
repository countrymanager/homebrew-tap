class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.0.0/pull-strings.sh"
  sha256 "7069dd5be0867ddac293636886d9afe6437a7e8c686162c4d05570fe57a6c609"
  version "1.0.0"

  def install
    bin.install "pull-strings.sh" => "countrymanager"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/countrymanager 2>&1", 1)
  end
end
