# Epitaph

*Version: ROLLING - "If we make it, we can all sit back and laugh."*

> Confusion, will be my epitaph...🎶

Complete theme for LeftWM. Epitaph is being developed as a starting point
for Gnu/Linux :penguin: users who are transitioning from a complete Desktop Environment to a minimalist WM, this theme does not
aim to be "simple" or "minimalistic", it aims to be complete and user friendly while keeping
modularity at first.

## News :newspaper:

- Epitaph has a new [wiki](https://github.com/VentGrey/Epitaph/wiki) page!
- Heavily refactored widgets + `up` & `camel` scripts for faster loading.
- Improved install script [Still a WIP]

## Overview

This configuration includes:
- POSIX shell `up` and `down` scripts for fast loading / reloading times
- Simple animations on windows powered by picom
- A simple `dmenu` application menu with icons
- A lot of script / program goodies for dmenu and leftwm!
- Compact workspaces
- Polybar / Lemonbar indicators for:
  - CPU use percentage
  - Memory use in GiB
  - Calendar + Hour in a simple format
  - Battery / AC Adapter indicator
  - Pulseaudio indicator
  - Music indicator (Polybar Only)
  - SSID indicator (Lemonbar Only)
  - Systray (Polybar Only)
- Doom One colorscheme (Taken from DT's [xmobar config](https://gitlab.com/dwt1/dtos-configs/-/blob/main/etc/skel/.config/xmobar/xmobarrc))
- Very tiny rust power manager
- An integrated script for wallpaper slideshows

# Polybar / Lemonbar switching

![NewBars](screenshots/bars.png)

> (Also yes, this is a King Crimson reference)

## Credit / Sources

Built on top of [Blue Coffee](https://github.com/Qwart376/Blue-Coffee) theme by @Qwart376.

And some inspiration / patches taken from these wonderful sources:

- @Suavesito-Olimpiada [dotfiles](https://github.com/Suavesito-Olimpiada/dotfiles) - No license but author [states](https://github.com/Suavesito-Olimpiada/dotfiles/blob/master/README.md?plain=1#L26) that his code can be used free as in freedom.

- @AethanFoot [leftwm-theme-dracula-rounded](https://github.com/AethanFoot/leftwm-theme-dracula-rounded) - No license as well. Author doesn't state permissions on code, will update as neccessary.

### Lemonbar programs credits / licenses

*All external programs retain their respective copyright notices*

- Both `battery.rs` and `time.c` programs are written by me and you can use them under the terms of the GPL-v2 ONLY.
- Both `wmdesk.c` and `wmtitle.c` are written by Christian Neukirchen and are licensed under the public domain.
- The `cpu-usage.c` program is written by Cosmin Cojocar under the terms of the GPL version 2.
- The `ram-usage.c` program was written by me and later improved by @Suavesito-Olimpiada, you can use it under the GPL-v2 or later.
- The `getvol.c` program is written by hvod2000. This has no license file but it's a public repository, will assume "UNLICENSE" here.

## Wallpaper artists credit

- Battery 0% was made by lowelllewolfe, please support her work by giving her a :heart: [here](https://www.instagram.com/lowelllewolfe/)
- The Orchid wallpaper is a personal modification I made based on the "Orchid" album from the band *Opeth*
- All "LeftWM" / "LeftOWO" One Dark wallpaper were made by me, from scratch. You can use those under the CC0 License (Public Domain).

## Screenshots

Here are some screenshots of how this will look on your machine (Screenshots are outdated but the theme hasn't changed much)

### Vanilla look
![01](screenshots/01.png)

### rofi + app list (only .desktop files)
![02](screenshots/02.png)

### "productive" screenshot
![03](screenshots/03.png)

## Rationale
Window Managers are awesome (no pun intended) by design, and being well configured they can be as good (or better) as a Desktop Environment, however, setup and ricing takes time...a **LOT** of time. Being a new WM user myself I'm writing this configuration to help transitioning users get a better experience when they
take their first steps in here.

As stated before, this config's main goal is **NOT** to be minimal, it is to be modular while being complete for new users, as their (mine) experience increases with this environment they should be able to trim down these files at their liking.

*But, why xDE tools?* you ask.

Simple, some other tools are a hell-like experience to configure, also editing dotfiles like a madman only helps by adding fuel to this hell, so LXDE / XFCE tools are lightweight, UNIX compliant and do one thing and do it well, of course I can add alternatives or change those tools over time given the right arguments to do so.

## Installation:

### Check for dependencies and compatibility + Compile rust goodies

You should run the `install` script, mind that it **WON'T**  install anything, we have `leftwm-theme` for that. This script will check if you have all the correct dependencies in order to install this theme.

### NO! I'm too lazy, do it for me! >.<

You can install using the official `leftwm-theme` tool.

`leftwm-theme install "Epitaph"`

**BUT** bear in mind that this won't work as expected since it is not possible to make "post-install hooks" in `leftwm-theme`, you'll have to do extra-work by yourself. Also it will install an older version of epitaph, I recommend you to install this theme manually until their PR #292 is up and running.

### Manual Installation (If you want the latest git commit)

This theme installation is pretty straightforward:

Extract this repository to `~/.config/leftwm/themes`

- Either rename it as `current` or create a symlink called `current` it to the above folder

- Soft reload with:  <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>

If everything is good, this theme should load up quickly if not, please check your dependencies. Feel free
to open requests, make suggestions and improvements, try not to get confused or that'll be your epitaph.

## Issues (Not worth using the issues tab up there)
- Improve install script
  - Ask the user if he/she wants lemonbar or polybar and omit unnecessary steps
  - Cleanup the `install` script code.
