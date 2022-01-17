<div align="center">
  <h1>🪦 Epitaph 🕊</h1>
  <h2>Confusion will be my epitaph. As I crawl a cracked and broken path</h2>
</div>
<img src="https://user-images.githubusercontent.com/24773698/146457499-87a8edca-9701-4a67-92fd-4b383119bc38.png" align="right">

Complete theme for LeftWM. Epitaph is being developed as a starting point
for Gnu/Linux :penguin: users who are transitioning from a complete Desktop Environment to a minimalist WM, this theme does not
aim to be "simple" or "minimalistic", it aims to be complete and user friendly while keeping
modularity at first.

> For credits and copyright see the bottom of this file.

## News :newspaper:

- Updated to comply with the latest leftwm(git) release 👨‍🔧

## Installation

Installation instructions can be found on the [wiki](https://github.com/VentGrey/Epitaph/wiki)

## Screenshots

### Vanilla look
![01](screenshots/01.png)

### dmenu + app list (only .desktop files)
![02](screenshots/02.png)

### "productive" screenshot
![03](screenshots/03.png)


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

## Other Copyright Notices

This software name and pictures don't intend to infringe copyright laws by illegally copying or claiming content that is not mine. This is made solely as a tribute to the band(s) I love and listen to, the original idea + artwork concept and registered trademarks are property of the bands mentioned below and their registered trademark holders.

Some bands that inspired this work are:
- King Crimson (In The Court Of The Crimson King - 1969)
- Camel (Mirage - 1974)
- Opeth (Orchid - 1995)
