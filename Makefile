.PHONY: all install recompile clean freeze check_dependencies copy_configs compile_modules

all: install

install: check_dependencies copy_configs
	@echo "Installation complete! You can now enjoy Epitaph on your system."
	@echo "Here are some additional steps you may want to take:"
	@echo "1. Read the Wiki for full customization options: https://github.com/VentGrey/Epitaph/wiki"
	@echo "IMPORTANT: You'll need to reload leftwm or restart your OS for changes to work properly."

recompile: compile_modules

clean:
	@echo "Cleaning binaries..."
	rm scripts/battery-notify

freeze:
	@echo "Freezing epitaph..."
	rm -rf .git .github ./config.ron ./config.rasi ./fonts

check_dependencies:
	@echo "Checking dependencies..."
	reqs=("leftwm" "rofi" "i3lock" "i3lock-fancy" "tilix" "rustc" "picom" "feh" "lxpolkit" "pulseaudio" "notify-send" "gnome-keyring" "polybar" "playerctl" "pamixer" "perl" "nemo" "tumbler" "ffmpegthumbnailer" "xdg-user-dirs" "dunst" "blueman-applet" "xss-lock");
	c=0;
	n=0;
	for p in $${reqs[@]}; do \
		if command -v $$p &>/dev/null; then \
			echo -e "[OK] $$p is installed!";
			((c++)) || true;
		else \
			echo -e "[ERROR] $$p is NOT installed!";
			((n++)) || true;
		fi;
	done;
	printf "%d of %d requirements were found.\\n" $$c $${#reqs[@]};
	printf "%d of %d requirements are missing.\\n" $$n $${#reqs[@]};
	if [ $$n -gt 1 ]; then \
		echo "Missing binaries were detected! Try installing them and re-run this script.";
		exit 1;
	fi

copy_configs:
	@echo "Copying the Epitaph configuration files..."
	cp ~/.config/leftwm/config.ron ~/.config/leftwm/config.ron.bak
	cp ./config.ron ~/.config/leftwm/config.ron
	mkdir -p "$(HOME)/.config/rofi"
	cp ./config.rasi "$(HOME)/.config/rofi/config.rasi"
	cp -R ./fonts "$(HOME)/.local/share/fonts"
	fc-cache -fv

compile_modules:
	@echo "Compiling modules..."
	rustc ./scripts/battery-notify.rs -C codegen-units=1 -C strip=symbols -C opt-level=z -C lto -C panic=abort -C target-cpu=native --edition=2021 -o ./scripts/battery-notify

format_perl:
	@echo "Formatting perl scripts..."
	perltidy -b --profile=scripts/.perltidyrc ./scripts/calendar.pl ./scripts/calendar-daemon.pl
