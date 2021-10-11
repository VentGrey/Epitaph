# Epitaph

> Version: 0.2.0

Complete theme for LeftWM. Epitaph is being developed as a starting point
for Loonex :penguin: users who are transitioning from a complete Desktop Environment to a minimalist WM, this theme does not
aim to be "simple" or "minimalistic", it aims to be complete and new-ser friendly while keeping 
modularity at first.

This configuration includes:
- Simple animations on windows powered by picom
- A simple rofi application menu (ultra-ripped off from Regolith)
- Workspaces in a compact way
- Polybar indicators for:
  - CPU use percentage
  - Memory use percentage
  - Calendar + Hour in a simple format
  - Battery / AC Adapter indicator
  - Pulseaudio indicator
  - Systray
  - Doom One colorscheme (Taken from DT's [xmobar config](https://gitlab.com/dwt1/dtos-configs/-/blob/main/etc/skel/.config/xmobar/xmobarrc))

> (Also yes, this is a King Crimson reference)

Built on top of Blue Coffee theme by Qwart376 and some inspiration / patches taken from @Suavesito-Olimpiada [dotfiles](https://github.com/Suavesito-Olimpiada/dotfiles)

A personal friend of mine made the wallpaper. She is the one to take credit for it, if you like
this theme **PLEASE** support her work giving her a :heart: [here](https://www.instagram.com/lowelllewolfe/)

## Screenshots

Here are some screenshots of how this will look on your machine

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

*But, why XFCE / LXDE tools?* you ask.

Simple, some other tools are a hell-like experience to configure, also editing dotfiles like a madman only helps by adding fuel to this hell, so LXDE / XFCE tools are lightweight, UNIX compliant and do one thing and do it well, of course I can add alternatives or change those tools over time given the right arguments to do so.


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
- `mate-polkit` or `mate-polkit-bin` (Manage privileges with the grace of MATE)
- `gnome-keyring-daemon` (Save secrets, ssh keys and NASA hacking passwords)
- `apparmor + aa-notify` (Userspace security made usabe by the user in it's space)
- `xfce4-settings` (Managing gtk dotfiles...for lazy people, like me, also we need `xfsettingsd`)
- `xfce4-power-manager` (Batteries included...well screen lock as well)
- `lxapperance` (Just for more theming thingies)
- `blueman` (We need a bluetooth applet)
- `nm-applet` (The good old systray applet, nothing beats it)
- `xscreensaver` (Somebody saaaaaave me)
- `notify-send` (We need this to report errors to you!)
- `pulseaudio` (The good alsa, the bad daemon & the ugly pipewire)

## Installation:

### Check for dependencies and compatibility

You should run the `install` script, mind that it **might** not install things properly (it hasn't been tested extensively), for now I recommend you to run it with the `--deps` flag just to check dependencies and nothing more. It should guide you on which packages are missing from your system.

### I want to do this manually, Go away!

This theme installation is pretty straightforward:

Extract this repository to `~/.config/leftwm/themes`

- Either rename it as `current` or create a symlink called `current` it to the above folder

- Soft reload with:  <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>

If everything is good, this theme should load up quickly if not, please check your dependencies. Feel free
to open requests, make suggestions and improvements, try not to get confused.

> Confusion, will be my epitaph

## Issues (Not worth using the tabs up there)
- Wallpaper + xscreensaver sometimes work and sometimes don't
- Notify users when something goes wrong
- Notify when something goes wrong
- Find a way to add a universal spotify / music label on polybar that's not written in snake rust (Python)
- (Ambitious :star:) Replace all polybar widgets with minimalistic Rust programs
