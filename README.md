# CountryManager Homebrew Tap

Homebrew formulae for [CountryManager](https://countrymanager.app) tooling.

## Install

```sh
brew install countrymanager/tap/countrymanager
countrymanager --version
```

The tool is a dependency-free POSIX shell script (`sh` + `curl` only), so it
also installs anywhere without Homebrew:

```sh
curl -fsSL https://countrymanager.app/install.sh | sh
```

or, to vendor it into a repo instead of installing it, which pins the version
for everyone on the project:

```sh
curl -fsSO https://countrymanager.app/pull-strings.sh && chmod +x pull-strings.sh
```

## Authentication

Tokens are issued per localization project under **Settings → Integrations**,
and carry scopes: `read` to pull and to list, `push` to write translation
values, `manage` to create, edit and delete keys.

Log in once and the token is stored in `~/.countrymanager` with `0600`
permissions:

```sh
countrymanager loc login --project <slug>
```

With several projects, log in per project. A bare `countrymanager loc login`
stores a default token that is tried for every project, and since a token is
bound to one project server-side you get a 403 rather than wrong data.

In CI, pass the token in the environment instead; it wins over anything stored:

```sh
export CM_LOC_TOKEN=cm_live_...
```

## Pull translations

Every locale and every string table of a project, as iOS `<code>.lproj`
folders (`.strings`, plus `.stringsdict` where the table has plural forms):

```sh
countrymanager loc sync --project <slug> --out-dir Sources/Translations/Resources
```

Each file lands via a hidden `.part` file, so an interrupted run never leaves a
half-written `.strings` behind, and a failed pull keeps the previous file rather
than truncating it.

## Manage keys

```sh
countrymanager loc keys list   --project <slug>
countrymanager loc keys create --project <slug> --name home.title \
  --description "Header on the home screen" --max-length 60 --tags nav,home
countrymanager loc keys update --project <slug> --name home.title --max-length 40
countrymanager loc keys delete --project <slug> --name home.title --yes
```

A key is metadata: name, description, string table, plural flag, length limit
and tags. `--table` is create-only, because which `.strings` file a key ships in
is build-affecting.

## Write translations

```sh
countrymanager loc values set --project <slug> --name home.title \
  --value en="Home" --value de="Startseite"

countrymanager loc values get --project <slug> --name home.title
```

Values are stored exactly as given, including leading, trailing and repeated
spaces. A write marks the cell `translated`, never `verified`, and re-writing
text that is already stored leaves the cell alone, so a scripted re-run does not
knock verified strings out of the next release bundle.

A plural key takes one value per CLDR category of that locale, and all of them
must be supplied or the request is refused without writing anything:

```sh
countrymanager loc values set --project <slug> --name items.count \
  --value de.one="Ein Element" --value de.other="%d Elemente"
```

## Environment

| Variable | Default | Purpose |
| --- | --- | --- |
| `CM_LOC_TOKEN` | unset | API token, overrides any stored one |
| `CM_LOC_URL` | `https://countrymanager.app` | API host |
| `CM_LOC_CONFIG` | `~/.countrymanager` | Token store location |

Exit codes: `0` success, `1` usage or auth error, `2` a request or download
failed.

The pre-namespace spellings still work, so an existing CI step or Xcode build
phase keeps running: `--project ... --out-dir ...` at the top level means
`loc sync`, and a bare `keys ...` means `loc keys ...`.
