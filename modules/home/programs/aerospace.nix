{ config, lib, pkgs, ... }:

{
  # AeroSpace config file
  home.file.".aerospace.toml".text = ''
    # AeroSpace tiling window manager config
    # Docs: https://nikitabobko.github.io/AeroSpace/guide

    # Start AeroSpace at login
    start-at-login = false  # Handled by launchd below

    # Gaps between windows
    [gaps]
    inner.horizontal = 8
    inner.vertical = 8
    outer.left = 8
    outer.bottom = 8
    outer.top = 8
    outer.right = 8

    # Main mode keybindings (default)
    [mode.main.binding]
    # Focus windows
    alt-h = "focus left"
    alt-j = "focus down"
    alt-k = "focus up"
    alt-l = "focus right"

    # Move windows
    alt-shift-h = "move left"
    alt-shift-j = "move down"
    alt-shift-k = "move up"
    alt-shift-l = "move right"

    # Workspaces
    alt-1 = "workspace 1"
    alt-2 = "workspace 2"
    alt-3 = "workspace 3"
    alt-4 = "workspace 4"
    alt-5 = "workspace 5"
    alt-6 = "workspace 6"
    alt-7 = "workspace 7"
    alt-8 = "workspace 8"
    alt-9 = "workspace 9"

    # Move to workspace
    alt-shift-1 = "move-node-to-workspace 1"
    alt-shift-2 = "move-node-to-workspace 2"
    alt-shift-3 = "move-node-to-workspace 3"
    alt-shift-4 = "move-node-to-workspace 4"
    alt-shift-5 = "move-node-to-workspace 5"
    alt-shift-6 = "move-node-to-workspace 6"
    alt-shift-7 = "move-node-to-workspace 7"
    alt-shift-8 = "move-node-to-workspace 8"
    alt-shift-9 = "move-node-to-workspace 9"

    # Layout
    alt-slash = "layout tiles horizontal vertical"
    alt-comma = "layout accordion horizontal vertical"
    alt-f = "fullscreen"
    alt-shift-space = "layout floating tiling"

    # Resize
    alt-minus = "resize smart -50"
    alt-equal = "resize smart +50"

    # Reload config
    alt-shift-c = "reload-config"

    # Float certain apps
    [[on-window-detected]]
    if.app-id = "com.apple.systempreferences"
    run = "layout floating"

    [[on-window-detected]]
    if.app-id = "com.apple.finder"
    run = "layout floating"

    [[on-window-detected]]
    if.app-id = "com.apple.calculator"
    run = "layout floating"

    [[on-window-detected]]
    if.app-id = "com.apple.ActivityMonitor"
    run = "layout floating"
  '';

  # Launchd agent to auto-start AeroSpace
  launchd.agents.aerospace = {
    enable = true;
    config = {
      Label = "com.user.aerospace";
      Program = "/run/current-system/sw/bin/aerospace";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/aerospace.log";
      StandardErrorPath = "/tmp/aerospace.err.log";
    };
  };
}
