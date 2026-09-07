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

Key descriptions are exported as comments. Pass `--no-comments` to leave them
out, which is safe to round-trip: a pushed file that says nothing about a key's
comment leaves the stored description untouched.

### One platform's keys

An iOS build and an Android build share one project, so by default both receive
every key. `--platform` narrows the sync to what that build actually ships:

```sh
countrymanager loc sync --project <slug> --out-dir Sources/Resources --platform ios
```

`loc sync` writes a whole `.lproj` tree and only speaks `.strings` +
`.stringsdict`. To fetch ONE file in one of the seven formats, to stdout or to
a path:

```sh
countrymanager loc pull --project <slug> --locale en --format next-intl \
  --out messages/en.json
countrymanager loc pull --project <slug> --locale en --format json --tag web
countrymanager loc tags list --project <slug>
```

A key is served unless it is tagged for a **different** platform. The platform
tags are `iOS`, `Android` and `API`; every other tag is a topic and is ignored
here, and a key carrying no platform tag at all ships everywhere.

| Key tags | `--platform ios` | `--platform android` |
| --- | --- | --- |
| none | served | served |
| `checkout` | served | served |
| `iOS` | served | dropped |
| `Android` | dropped | served |
| `iOS`, `Android` | served | served |

So only the exceptions need marking: tag the Play-Store-only string `Android`
and it drops out of the iOS sync, while the untagged bulk of the catalog keeps
flowing to both. A string table whose every key belongs to the other platform
drops out entirely rather than landing as an empty `<Table>.strings`.

The value is case-insensitive. An unrecognized one fails the run rather than
falling back to the whole catalog, and so does an empty one - `--platform
"$PLATFORM"` with the variable unset in CI must not quietly ship the other
platform's strings.

## Manage keys

```sh
countrymanager loc keys list   --project <slug>
countrymanager loc keys list   --project <slug> --platform ios
countrymanager loc keys create --project <slug> --name home.title \
  --description "Header on the home screen" --max-length 60 --tags nav,home
countrymanager loc keys update --project <slug> --name home.title --max-length 40
countrymanager loc keys update --project <slug> --name home.title --add-tag web
countrymanager loc keys update --project <slug> --name home.title --remove-tag nav
countrymanager loc keys delete --project <slug> --name home.title --yes
```

`--tags` replaces the whole set; `--add-tag` and `--remove-tag` edit it in
place and are repeatable.

A key is metadata: name, description, string table, plural flag, length limit
and tags. `--table` is create-only, because which `.strings` file a key ships in
is build-affecting. `--platform` applies to `list` only, and answers what a sync
would deliver without downloading anything. Writing `--tags android` stores
`Android`, so a platform tag is one however it is typed.

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
