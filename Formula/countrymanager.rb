class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.0.1/pull-strings.sh"
  sha256 "9450b0db78614db4c8e90f45efe5296405000a9168d694cb65c2222c190c7ca5"

  def install
    bin.install "pull-strings.sh" => "countrymanager"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/countrymanager 2>&1", 1)
  end
end
