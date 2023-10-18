#!/usr/bin/env perl
# Epitaph Music Control. Small perl 5 script to make a simple GUI wrapper around
# cmus-remote.
#
# Copyright (C) [2023] [VentGrey]
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use strict;
use warnings;
use utf8;
use v5.36;
use Gtk3 '-init' ;
use Glib ('TRUE', 'FALSE');

# Ensure only one instance is running
my $pid = `pgrep -f $0`;
chomp $pid;
if ($pid && $pid != $$) {
    die "Another instance of this script is already running." ;
}

my $current_position = 0;
my $total_duration = 0;
my $progress_bar;

sub update_song_info {
    my ($label_title, $label_artist, $label_album, $label_genre, $label_date, $label_track) = @_;

    my $status = `cmus-remote -Q`;
    if ($status =~ /tag title (.+)/) {
        $label_title->set_text("Title: $1");
    }
    if ($status =~ /tag artist (.+)/) {
        $label_artist->set_text("Artist: $1");
    }
    if ($status =~ /tag album (.+)/) {
        $label_album->set_text("Album: $1");
    }

    if ($status =~ /tag genre (.+)/) {
        my $icon = "";
        my $genre = $1;
        my %genre_icons = (
            "progressive" => "⭐",
            "rock" => "🎸",
            "jazz" => "🎷",
            "pop" => "🎤",
            "grunge" => "🧑‍🎤",
            "classical music" => "🎼",
            "r&b" => "🎹",
            "kpop" => "🇰🇷",
            "metal" => "🤘",
            "fusion" => "🌀",
            "wave" => "🌊",
            "doom" => "💀",
            "cumbia" => "💃",
            "emo" => "☠️",
            );

        foreach my $key (keys %genre_icons) {
            if ($genre =~ /$key$/i) {
                $icon = $genre_icons{$key};
                last;
            }
        }

        $label_genre->set_text("$icon Genre: $genre");
    }
    
    if ($status =~ /tag date (.+)/) {
        $label_date->set_text("Release Date: $1");
    }

    if ($status =~ /tag tracknumber (.+)/) {
        $label_track->set_text("Track: $1");
    }

    if ($status =~ /position (\d+)/) {
        $current_position = $1;
    }

    if ($status =~ /duration (\d+)/) {
        $total_duration = $1;
    }

    if ($total_duration > 0) {
        $progress_bar->set_fraction($current_position / $total_duration);
    }
}

my $cmus_check = `pgrep cmus`;
if (!$cmus_check) {
    system("notify-send", "Cmus is not running!");
    die "cmus is not running.\n";
}

my $window = Gtk3::Window->new('popup');
$window->set_decorated(0);
$window->set_keep_above(1);
$window->set_title("Epitaph Cmus Control");
$window->signal_connect('delete_event' => sub { Gtk3::main_quit; });
my ($x, $y) = split /,/,
    `xdotool getmouselocation --shell 2>/dev/null | grep -E 'X|Y' | cut -d= -f2 | paste -sd "," -`
    || (0, 0);
$window->move($x, $y);

my $vbox = Gtk3::Box->new('vertical', 5);
$vbox->set_margin_start(10);
$vbox->set_margin_end(10);
$vbox->set_margin_top(10);
$vbox->set_margin_bottom(10);
$window->add($vbox);

my $label_title = Gtk3::Label->new('Title: Unknown');
my $label_artist = Gtk3::Label->new('Artist: Unknown');
my $label_album = Gtk3::Label->new('Album: Unknown');
my $label_genre = Gtk3::Label->new('Genre: Unknown');
my $label_date = Gtk3::Label->new('Release Date: Unknown');
my $label_track = Gtk3::Label->new('Track: Unknown');

$vbox->pack_start($label_title, TRUE, TRUE, 0);
$vbox->pack_start($label_artist, TRUE, TRUE, 0);
$vbox->pack_start($label_album, TRUE, TRUE, 0);
$vbox->pack_start($label_genre, TRUE, TRUE, 0);
$vbox->pack_start($label_date, TRUE, TRUE, 0);
$vbox->pack_start($label_track, TRUE, TRUE, 0);

$progress_bar = Gtk3::ProgressBar->new();
$vbox->pack_start($progress_bar, TRUE, TRUE, 0);

# Actualiza la información al inicio
update_song_info($label_title, $label_artist, $label_album, $label_genre, $label_date, $label_track, $progress_bar);

# Horizontal box for volume controls
my $hbox_controls = Gtk3::Box->new('horizontal', 5);

my $btn_play = Gtk3::Button->new_with_label('󰐎');
my $btn_stop = Gtk3::Button->new_with_label('󰓛');
my $btn_prev = Gtk3::Button->new_with_label('󰒮');
my $btn_next = Gtk3::Button->new_with_label('󰒭');

$hbox_controls->pack_start($btn_prev, TRUE, TRUE, 0);
$hbox_controls->pack_start($btn_play, TRUE, TRUE, 0);
$hbox_controls->pack_start($btn_stop, TRUE, TRUE, 0);
$hbox_controls->pack_start($btn_next, TRUE, TRUE, 0);

$vbox->pack_start($hbox_controls, TRUE, TRUE, 0);

# Close button
my $btn_close = Gtk3::Button->new_with_label('Close');
$vbox->pack_start($btn_close, TRUE, TRUE, 0);
$btn_close->signal_connect(clicked => sub {
    Gtk3::main_quit();
});

$btn_play->signal_connect(clicked => sub {
    system("cmus-remote --pause");
});

$btn_stop->signal_connect(clicked => sub {
    system("cmus-remote --stop");
});

$btn_prev->signal_connect(clicked => sub {
    system("cmus-remote --prev");
});

$btn_next->signal_connect(clicked => sub {
    system("cmus-remote --next");
});

Glib::Timeout->add(1000, sub { # 1000 ms = 1 second
update_song_info($label_title, $label_artist, $label_album, $label_genre, $label_date, $label_track, $progress_bar);
    return TRUE; # Return true to keep the timeout active
});

$window->show_all();

Gtk3::main();

