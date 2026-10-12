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

Then install the extension. Release Firefox only installs signed add-ons for
good; sign it once as unlisted (not public, signed automatically) with an AMO
API key ([addons.mozilla.org/developers/addon/api/key](https://addons.mozilla.org/developers/addon/api/key/)):

```sh
npx web-ext sign --channel=unlisted --api-key=… --api-secret=…
```

and open the `.xpi` from `web-ext-artifacts/` in Firefox. Disable laser or
nord in `about:addons` if they are installed.

To try it without signing: `about:debugging#/runtime/this-firefox`,
**Load Temporary Add-on…**, pick `manifest.json`. It stays until Firefox
restarts.

## Build

```sh
npx web-ext lint
npx web-ext build    # web-ext-artifacts/desktop_theme-<version>.zip
```

The host and `install.sh` stay out of the package (`web-ext-config.mjs`).

## License

[Unlicense](LICENSE).
