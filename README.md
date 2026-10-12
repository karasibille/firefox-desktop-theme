# Desktop theme for Firefox

Firefox extension that follows the color theme of the desktop: `theme laser`
or `theme nord` in [dotfiles](https://github.com/karasibille/dotfiles) also
switches Firefox, live, without restarting it. Any new theme of the dotfiles
reaches Firefox without a new add-on.

Replaces the static themes [firefox-laser](https://github.com/karasibille/firefox-laser)
and [firefox-nord](https://github.com/karasibille/firefox-nord) on the desktop,
with the same colors and roles.

## How it works

1. `bin/theme` of the dotfiles writes the Firefox colors (the `theme` key of a
   theme manifest) to `~/.local/state/theme/firefox.json`.
2. Firefox starts `host/firefox-desktop-theme-host`, a native messaging host,
   when the extension loads. The host sends the file to the extension, then
   again each time it changes (checked every half second), and exits with
   Firefox.
3. The extension applies it with `browser.theme.update()`.

| Firefox key                                              | Theme role                                       |
|----------------------------------------------------------|--------------------------------------------------|
| `frame`, `popup`                                         | `background`                                     |
| `toolbar`                                                | `color0`                                         |
| `toolbar_field`                                          | `theme.selection`                                |
| `toolbar_text`, `toolbar_field_text`, `popup_text`       | `theme.firefox.foreground` (default `foreground`) |
| `tab_background_text`, `toolbar_field_highlight`         | `theme.accent`                                   |
| `tab_line`, `tab_loading`                                | `color5`                                         |
| `toolbar_bottom_separator`, `toolbar_vertical_separator` | `color1`                                         |

## Install

Declare the native host to Firefox (writes
`~/.mozilla/native-messaging-hosts/firefox_desktop_theme.json`, pointing to
this clone, so keep it in place):

```sh
./install.sh
```

Then download `desktop-theme-<version>.xpi` from the
[latest release](https://github.com/karasibille/firefox-desktop-theme/releases/latest),
open it in Firefox and confirm. Disable laser or nord in `about:addons` if
they are installed. An unlisted add-on does not update itself: install the
new `.xpi` after a release.

To try it without signing: `about:debugging#/runtime/this-firefox`,
**Load Temporary Add-on…**, pick `manifest.json`. It stays until Firefox
restarts.

## Build

```sh
npx web-ext lint
npx web-ext build    # web-ext-artifacts/desktop_theme-<version>.zip
```

The host and `install.sh` stay out of the package (`web-ext-config.mjs`).

## Release

Release Firefox only installs add-ons signed by addons.mozilla.org. Raise
`version` in `manifest.json`, commit, then push a tag with that version:

```sh
git tag v1.1 && git push origin v1.1
```

The release workflow checks that the tag matches the manifest, lints, signs
the extension as unlisted (signed automatically, not published on AMO) and
creates a GitHub release with `desktop-theme-<version>.xpi`. It needs an AMO
API key ([addons.mozilla.org/developers/addon/api/key](https://addons.mozilla.org/developers/addon/api/key/))
in the repository secrets `AMO_JWT_ISSUER` and `AMO_JWT_SECRET`.

The add-on ID in `browser_specific_settings` must stay the same, or AMO
treats the upload as another add-on.

## License

[Unlicense](LICENSE).
