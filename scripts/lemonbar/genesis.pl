#!/usr/bin/perl
use strict;
use warnings;
use v5.36; # Modern perl

use AnyEvent; # Make this script async
use POSIX; # Use handy posix functions
use Fcntl ':flock'; # Locking constants

use FindBin;
use lib "$FindBin::Bin/Modules/";

use WorkspaceModule;
use MusicModule;
use KeyboardModule;
use WifiModule;
use DateModule;
use VolumeModule;
use BatteryModule;

open(my $lock_fh, '>', "/tmp/genesis.lock") or die "Could not create lock file: $!";
flock($lock_fh, LOCK_EX | LOCK_NB) or die "Another instance of this script is already running.";

# Change process name to make tracking easy.
$0="Genesis";

# fifo path for UNIX mkfifo
my $pipe = "/tmp/lemonbar-fifo";

unless (-p $pipe) {
  mkfifo($pipe, 0700) or die "Fifo could not be created! $!";
}

my $cv = AnyEvent->condvar;

# Print any given message into the FIFO file.
sub print_pipe($message) {
  open my $fh, ">", $pipe or die "No se puede abrir el pipe: $!";
  print "DEBUG: Sending to FIFO: $message\n";
  say $fh $message;
  close $fh;
}

my %modules = (
    start  => [],
    middle => [],
    end    => []
);

sub update_module($position, $index, $content) {
    $modules{$position}->[$index] = $content;
}

sub print_bar {
    my $output = "%{l} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{start}})
               . "%{c} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{middle}})
               . "%{r} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{end}});
    print "DEBUG: Constructed output for bar: $output\n";
    print_pipe("$output %{F#313244}%{F#cdd6f4w} %{A:~/.config/leftwm/themes/Epitaph/scripts/rofi/power-menu:}⏻%{A}")
}

# Subroutine for bar refresh.
sub update_bar {
    print_bar();
}

########Modules#################################################################
# Modules listed here are any .pl files present in ./modules, to make this     #
# async we have to call those modules in AnyEvent timers, not all modules      #
# require a timer poll, like the workspaces one.                               #
#                                                                              #
#   - Feel free to add more modules moderately to avoid I/O errors in lemonbar #
#   - If you wish to contribute a module please do so                          #
################################################################################

#===== Bar printer =====
# This module re-prints the bar every few seconds (timer) to ensure a constant
# output to prevent bugs if lemonbar were to experience a bad formatter.
my $barprinter = AnyEvent->timer(
    after => 0,
    interval => 2,
    cb => \&update_bar
);

 
#===== Leftwm-state =====
my $leftwm_state_handle = WorkspaceModule::listen_leftwm_state(sub {
    my $line = shift;
    print "DEBUG: Received from leftwm-state: $line\n";
    chomp $line;
    update_module('start', 0, "%{A:/usr/bin/rofi -show drun:}Perl %{F#74c7ec}%{F#cdd6f4}%{A}|$line");
    print_bar();
});

#===== CMUS Bar =====
my $music_values = MusicModule::listen_cmus(sub {
    my $music = shift;
    print "DEBUG: Received CMUS values: $music\n";
    update_module('middle', 0, "%{A:perl ~/.config/leftwm/themes/Epitaph/scripts/cmuscontrol.pl:}$music%{A}");
});

#===== Keyboard Distribution =====
my $keyboard_handle = KeyboardModule::listen_keyboard(sub {
    my $layout = shift;
    print "DEBUG: Received keyboard layout: $layout\n";
    update_module('end', 0, "%{A:bash ~/.config/leftwm/themes/Epitaph/scripts/rofi/keyboardlayout:}$layout%{A}");
});

#===== Wifi Connection =====
my $wifi_handle = WifiModule::listen_wifi(sub {
    my $wifi = shift;
    print "DEBUG: Received wireless info: $wifi\n";
    update_module('end', 1, "%{A:tilix -e nmtui:}$wifi%{A}");
});

#===== Date & Time =====
my $date_handle = DateModule::listen_date(sub {
    my $date = shift;
    print "DEBUG: Received date: $date\n";
    update_module('end', 2, "%{A:perl ~/.config/leftwm/themes/Epitaph/scripts/calendar.pl:}$date%{A}");
});

# ===== Battery =====
# (Args: BATTERY_ID to monitor. e.g: "BAT0" or "BAT1")
# =====
my $battery_handle = BatteryModule::listen_battery("BAT0", sub {
    my $info = shift;
    print "DEBUG: Received from BatteryModule: $info\n";
    update_module('end', 3, "$info");
    print_bar();
});


# ===== Volume =====
my $volume_handle = VolumeModule::listen_volume(sub {
    my $volume = shift;
    print "DEBUG: Received volume: $volume\n";
    update_module('end', 4, "%{A:pavucontrol:}$volume%{A}");
    print_bar();
});

AnyEvent->condvar->recv;
