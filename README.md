<div align="center">
  <h1>🪦 Epitaph 🕊</h1>
  <h2>The wall on which the prophets wrote...</h2>
</div>
<img src="https://m.media-amazon.com/images/I/61r34SB-E2L._AC_SX425_.jpg" align="right">

# 🌟 A complete, progressive-rock inspired theme for LeftWM. 🌟

<p align="center"> 
  <a href="https://github.com/VentGrey/Epitaph/wiki">Installation Guide</a> | 
  <a href="https://github.com/VentGrey/Epitaph#-screenshots">Screenshots</a> | 
  <a href="https://github.com/VentGrey/Epitaph#music-copyright-notices">Music Copyright Notice</a> 
</p>

<p align="center"> 
  <img alt="License" src="https://img.shields.io/github/license/VentGrey/Epitaph?color=success&label=License&style=for-the-badge">
  <img alt="Last Commit" src="https://img.shields.io/github/last-commit/VentGrey/Epitaph?style=for-the-badge">
  <img alt="GitHub stars" src="https://img.shields.io/github/stars/VentGrey/Epitaph?style=for-the-badge">
</p>

> [!IMPORTANT]
> This repository is still alive. However, since `leftwm` development is stable enough. Not many changes are or will be made unless that involves a breaking change in leftwm
> Use the issues tab to request features.

Epitaph is being developed as a starting point for Gnu/Linux 🐧 users who are transitioning from a complete Desktop Environment to a great WM. This theme does not aim to be "simple" or "minimalistic", it aims to be complete and user-friendly as I can make it. I try to make Epitaph carefully crafted to provide you with all the tools you need to personalize your workspace and streamline your workflow. So why settle for less when you can have it all *just work* (kinda) with Epitaph?

Suggestions, ideas, or requests are always welcome! Please feel free to open an issue.

> **DISCLAIMER**: I do not recommend you to use Epitaph and follow it's updates, it changes a lot. It's best for you to install Epitaph and then freeze it to use it as a starting ground for your own LeftWM theme.

## :newspaper: News

- Updated perl dependencies from: v5.36 -> v5.40 
  - If your distribution doesn't have v5.40 you can revert them manually. They still work the same :) 
- Update copyright notices in module source code

## :rocket: Installation

Installation instructions can be found on the [wiki](https://github.com/VentGrey/Epitaph/wiki)

## 📷 Screenshots

### Polybar 👽 (As modern as I knew)
Beautifully configured polybar with clickable areas and useful RoFi scripts for a better experience! Polybar includes:

- A clickable `applist` menu changeable with the [select badge](https://github.com/VentGrey/Epitaph/blob/master/scripts/rofi/select-badge) script, use <kbd>Ctrl<kbd/> <kbd>+<kbd/> <kbd>Tab<kbd/> to navigate between `rofi` tabs. `TODO: Keybind this.`

- EWMH (xworkspaces) list, the current tag is colored blue, occupied tags are yellow, available tags are FG color and urgent tags are colored red. You can navigate between workspaces with clicks oy your scrollwheel.

- Spotify/Cmus song indicator. Buttons send playerctl signals to manipulate the current player. Clicking it will open a small GTK3 popup with CMUS only controls + song information.

- Keyboard layout indicator, clicking it will run the [keyboard selection script](https://github.com/VentGrey/Epitaph/blob/master/scripts/rofi/keyboardlayout).

- Wifi status icon + singal intensity (%)
- Date & Time. Clicking it will open the [Tiny Epitaph Calendar](https://github.com/VentGrey/Epitaph/wiki/Goodie:-epitaph-calendar) script.
- Animated battery indicator
- Volume indicator. You can click on it to mute audio or use your scrollwheel to control the volume there.
- Systray (Dynamically sized)

![01](https://github.com/VentGrey/Epitaph/assets/24773698/93f5787b-5104-4767-8be5-e707e7c1aa23)

### Lemonbar 👾 (A reliable bar managed by a reliable language)
Beautifully configured async lemonbar with clickable areas and useful RoFi scripts for a better experience! Genesis includes:

![Screenshot_2023-10-23](https://github.com/VentGrey/Epitaph/assets/24773698/b555b86a-12cc-467b-ad6b-4aea9c83b4b6)


- Darker color than Polybar without rounded edges (more adequate for lemonbar)
- Better colors
- To read more about Genesis modules shown in the bar, please [read the wiki](https://github.com/VentGrey/Epitaph/wiki/Genesis:-core).

## Overview

This theme includes:
- 🐚 POSIX shell `up` and `down` scripts for fast loading / reloading times.
- 🌪️ Simple animations on windows. Powered by picom. No heavy blurs, rounded corners or anything that can be considered *GPU wasting*.
- 🌟 Beautifully configured polybar/lemonbar.
- 📚 Extensive documentation.
- 🎨 Catppucchin Mocha colorscheme.
- :battery: Very tiny rust power manager.
- 🖼️ An integrated script for wallpaper slideshows.

## Credit / Sources

> Scripts are marked under the GPLv3 or later. Feel free to take them with either licenses (GPLv3+ or BSD-3-Clause) at your convenience.

🚨 If you want your source / mention & material to be removed from here, please send an email or open an issue and read the copyright notice at the end of this file. 🚨

This project is built on top of the [Blue Coffee](https://github.com/Qwart376/Blue-Coffee) theme by @Qwart376 (originally licensed under the MIT license).

I drew inspiration and patches from the following sources:

- @Suavesito-Olimpiada [dotfiles](https://github.com/Suavesito-Olimpiada/dotfiles) - No license but author [states](https://github.com/Suavesito-Olimpiada/dotfiles/blob/master/README.md?plain=1#L26) that his code can be used free as in freedom. I would debate if this is for the good of humanity.

- @AethanFoot [leftwm-theme-dracula-rounded](https://github.com/AethanFoot/leftwm-theme-dracula-rounded) - No license as well. Author doesn't state permissions on code, will update as neccessary.

- @Catppucchin [RoFi config](https://github.com/catppuccin/rofi) - MIT License
- @Catppucchin [Colorscheme](https://github.com/catppuccin/) - MIT License

- Polybar style inspiration taken from: [ArchCraft](https://archcraft.io/), [DT](https://gitlab.com/dtos/dtos) and [ChadWM](https://github.com/siduck/chadwm).

- Assets in this theme include:
  - A picture icon taken from [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

## 🖼️ Current wallpaper artists credit

- Erina the cat, Camel, Steven Wilson and King Crimson wallpapers were made by [AreliSuleima](https://github.com/arelisuleima).
- The Orchid wallpaper is a personal modification I made based on the "Orchid" album from the band *Opeth*
- Added wallpapers taken from [Linkin Park - Lost](https://www.youtube.com/watch?v=7NK_JOkuSVY) music video. 
- Catppucchin variants of wallpapers extracted from Alcest & Camel

Credits are too long, see the copyright notice below for full credit.

## 🎨  Legacy wallpaper artists credit

These credits here are to preserve the copyright / attribution to people who contributed to the look and feel of Epitaph in the past.

- Battery 0% was made by lowelllewolfe, please support her work by giving her a :heart: [here](https://www.instagram.com/lowelllewolfe/)
- Emojis used in the wallpapers are the googlefonts/noto-emoji project. Which it's under the Apache License 2.0

## Music Copyright Notices

To be clear, I do not claim ownership of any of the ideas, names, or album art associated with the songs referenced here. I do not intend to harm or violate any copyright laws or use any of the artists' material in harmful ways.

This software name and pictures don't intend to infringe copyright laws by illegally copying or claiming content that is not mine. This is made solely as a tribute to the band(s) I love and listen to. I respect the original idea, artwork concept, and registered trademarks, which are the property of the bands mentioned below and their registered trademark holders.

Some bands that inspired this work are:
- King Crimson (In The Court Of The Crimson King - 1969)
- Camel (Mirage - 1974)
- Opeth (Orchid - 1995)
- Steven Wilson (The Raven That Refused To Sing - 2013)
- Alcest
  - Kodama (2016)
  - Ecailles de Lune (2010)
- (For the "Linkin Park - Lost" wallpapers): Alasdair Willson, Andrew Hawryluk, Colby Beckett, Daniels Gulbis, Egor Mark, Kim Ho, Torell Vowles, Toros Kose, Maciej Kuciara, pplpleasr, jun._.ka & Anthony Scott Burns
