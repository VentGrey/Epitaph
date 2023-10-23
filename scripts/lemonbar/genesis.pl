#!/usr/bin/perl
use strict;
use warnings;
use v5.36; # Modern perl


use AnyEvent; # Make this script async
use POSIX; # Use handy posix functions

use FindBin;
use lib "$FindBin::Bin/Modules/";

# Print current tag + active window
use WorkspaceModule;
use MusicModule;
use KeyboardModule;
use WifiModule;
use DateModule;
use VolumeModule;
use BatteryModule;

# Change process name to make tracking easy.
$0="Genesis";

# fifo path for UNIX mkfifo
my $pipe = "/tmp/lemonbar-fifo";

unless (-p $pipe) {
  mkfifo($pipe, 0700) or die "Fifo could not be created! $!";
}

my $cv = AnyEvent->condvar;

# Print any given message into the FIFO file.
sub print_pipe {
  open my $fh, ">", $pipe or die "No se puede abrir el pipe: $!";
  my $message = $_[0];
  print "DEBUG: Sending to FIFO: $message\n";
  say $fh $message;
  close $fh;
}

# Hash para almacenar los contenidos de los módulos
my %modules = (
    start  => [],
    middle => [],
    end    => []
);

# Función para actualizar un módulo en una posición específica
sub update_module {
    my ($position, $index, $content) = @_;
    $modules{$position}->[$index] = $content;
}

# Función para consolidar y enviar la salida al FIFO
sub print_bar {
    my $output = "%{l} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{start}})
               . "%{c} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{middle}})
               . "%{r} " . join(" %{F#313244}%{F#cdd6f4w} ", @{$modules{end}});
    print "DEBUG: Constructed output for bar: $output\n";
    print_pipe($output)}

########Modules#################################################################
# Modules listed here are any .pl files present in ./modules, to make this     #
# async we have to call those modules in AnyEvent timers, not all modules      #
# require a timer poll, like the workspaces one.                               #
#                                                                              #
#   - Feel free to add more modules moderately to avoid I/O errors in lemonbar #
#   - If you wish to contribute a module please do so                          #
################################################################################

#===== Leftwm-state =====
my $leftwm_state_handle = WorkspaceModule::listen_leftwm_state(sub {
    my $line = shift;
    print "DEBUG: Received from leftwm-state: $line\n";
    chomp $line;
    update_module('start', 0, "Camel %{F#fab387}%{F#cdd6f4}|$line");
    print_bar();
});

#===== CMUS Bar =====
my $music_values = MusicModule::listen_cmus(sub {
    my $music = shift;
    print "DEBUG: Received CMUS values: $music/n";
    update_module('middle', 0, $music);
});

#===== Keyboard Distribution =====
my $keyboard_handle = KeyboardModule::listen_keyboard(sub {
    my $layout = shift;
    print "DEBUG: Received keyboard layout: $layout\n";
    update_module('end', 0, $layout);
});

#===== Wifi Connection =====
my $wifi_handle = WifiModule::listen_wifi(sub {
    my $wifi = shift;
    print "DEBUG: Received wireless info: $wifi\n";
    update_module('end', 1, $wifi);
});

#===== Date & Time =====
my $date_handle = DateModule::listen_date(sub {
    my $date = shift;
    print "DEBUG: Received date: $date\n";
    update_module('end', 2, $date);
});

# ===== Battery =====
# (Args: BATTERY_ID to monitor. e.g: "BAT0" or "BAT1")
# =====
my $battery_handle = BatteryModule::listen_battery("BAT0", sub {
    my $info = shift;
    print "DEBUG: Received from BatteryModule: $info\n";
    update_module('end', 3, $info);
    print_bar();
});


# ===== Volume =====
my $volume_handle = VolumeModule::listen_volume(sub {
    my $volume = shift;
    print "DEBUG: Received volume: $volume\n";
    update_module('end', 4, $volume);
    print_bar();
});

AnyEvent->condvar->recv;
