# CountryManager Homebrew Tap

Homebrew formulae for [CountryManager](https://countrymanager.app) tooling.

## Install

```sh
brew install countrymanager/tap/countrymanager
```

## Usage

Pull every locale of a localization project as iOS `<code>.lproj` folders
(`.strings` + `.stringsdict`):

```sh
CM_LOC_TOKEN=cm_live_... countrymanager --project <slug> --out-dir Sources/Translations/Resources
```

- `CM_LOC_TOKEN` (required): API token, issued in your project's
  Settings → Integrations screen.
- `CM_LOC_URL` (optional): API host override, defaults to
  `https://countrymanager.app`.

The tool is a dependency-free POSIX shell script (`sh` + `curl` only), so it
also runs anywhere without Homebrew:

```sh
curl -fsSO https://countrymanager.app/pull-strings.sh && chmod +x pull-strings.sh
```
