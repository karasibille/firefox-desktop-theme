// The host sends the current theme when it starts, then a new one on each switch
const port = browser.runtime.connectNative("firefox_desktop_theme");

port.onMessage.addListener((theme) => browser.theme.update(theme));

port.onDisconnect.addListener((p) => {
  if (p.error) {
    console.error(`firefox_desktop_theme host: ${p.error.message}`);
  }
});
