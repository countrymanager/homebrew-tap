class Countrymanager < Formula
  desc "Pull localization files (.strings/.stringsdict) from CountryManager"
  homepage "https://countrymanager.app"
  url "https://github.com/countrymanager/homebrew-tap/releases/download/v1.1.0/pull-strings.sh"
  sha256 "1415dff842b9c594fd7639a9e5cefae23a6abd3fe01b8a6604c0e02a6334d1e5"

  def install
    bin.install "pull-strings.sh" => "countrymanager"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/countrymanager 2>&1", 1)
  end
end
