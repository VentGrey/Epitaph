# Epitaph

Complete theme for LeftWM. Epitaph is being developed as a starting point
for Loonex users who are transitioning from a complete DE to a minimalist WM, this theme does not
aim to be "simple" or "minimalistic", it aims to be complete and new-ser friendly while keeping 
modularity at first.

This configuration includes:
- Simple animations on windows powered by compton
- A simple rofi application menu (ultra-ripped off from Regolith)
- Workspaces with fancy icons
- Polybar indicators for:
  - CPU use percentage
  - Memory use percentage
  - Calendar + Hour in a simple format
  - Battery / AC indicator
  - Systray
  - Doom One colorscheme (Taken from DT's [xmobar config](https://gitlab.com/dwt1/dtos-configs/-/blob/main/etc/skel/.config/xmobar/xmobarrc))

> (Also yes, this is a King Crimson reference)

Built on top of Blue Coffee theme by Qwart376

A personal friend of mine made the wallpaper. She is the one to take credit for it, if you like
this theme please support her work [here](https://www.instagram.com/lowelllewolfe/)

## Screenshots

Here are some screenshots of how this will look on your machine

### Vanilla look
![01](screenshots/01.png)

### rofi + app list (only .desktop files)
![02](screenshots/02.png)

### "productive" screenshot
![03](screenshots/03.png)

## Rationale
Window Managers are awesome by design, and being well configured they can be as good (or better) as a Desktop Environment, however, setup and ricing takes time...a **LOT** of time. Being a new WM user myself I'm writing this configuration to help transitioning users get a better experience when they
take their first steps in here.

As stated before, this config's main goal is **NOT** to be minimal, it is to be modular while being complete for new users, as their (mine) experience increases with this environment they should be able to trim down these files at their liking.

*But, why MATE tools?* you ask.

Simple, I'm transitioning from MATE, of course I'll add alternatives over time or simply make a simple install script to guide you / let you choose options at your liking.

## Prerequisites / Dependencies
This theme needs the following dependencies to work properly:

- `leftwm` (duh)
- `polybar`(Status bar written in very unsafe rust...or very safe C++)
- `rofi` (dmenu for people who don't like dmenu)
- `rofi-themes` (you can get those [here](https://github.com/adi1090x/rofi))
- `picom (THE STABLE ONE!)` (Nice blur, shadow and transparency effects brought to you by the gazillionth fork of a composter)
- [OPTIONAL]`compton` (Just in case picom doesn't work, we can always fall back to the ugly one)
- `feh` (Simple tool for an awesome wallpaper)
- `xdg-user-dirs-gtk` (Keep your home folders in your home language)
- `mate-polkit` (Manage privileges with the grace of MATE)
- `gnome-keyring-daemon` (Save secrets, ssh keys and NASA hacking passwords)
- `apparmor + aa-notify` (Userspace security made usabe by the user in it's space)
- `mate-settings-daemon` (Managing gtk dotfiles...for lazy people, like me)
- `blueman` (We need a bluetooth applet)
- `nm-applet` (The good old systray applet, nothing beats it)
- `mate-screensaver` (Somebody saaaaaave me)
- `pulseaudio` (The good alsa, the bad daemon & the ugly pipewire)

## Installation:

Extract this repository to `~/.config/leftwm/themes`

-Either rename it as `current` or create a symlink called `current` it to the above folder

-Soft reload with:  <kbd>Super+Shift+R</kbd>

## Issues (Not worth using the tabs up there)
- Add alternatives to MATE services
- Compton config doesn't render the color bar of the volume/brightness dialog properly.
- Bash is kinda "ay", port `up` and `down` to `dash`.
- Alacritty is not transparent yet (idk how to do it)
- Screen Capture Key doesn't do anything
- Mouse switches windows on hover, not on click
- Find a way to add a universal spotify / music label on polybar that's not written in snake rust (Python)
- (Ambitious :star:) Replace all polybar widgets with minimalistic Rust programs
