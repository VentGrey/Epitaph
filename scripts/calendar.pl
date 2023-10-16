#!/usr/bin/env perl
# Epitaph Calendar. Small perl 5 script to make a simple calendar with reminders
# using GTK3. The reminders file is stored as a .txt, use at your discretion.
#
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

use strict ;
use warnings ;

use Gtk3 '-init' ;
use DateTime ;
use Time::Local ;

# Ensure only one instance is running
my $pid = `pgrep -f $0` ;
chomp $pid ;
if ($pid && $pid != $$) {
    die "Another instance of this script is already running." ;
}

my $window = Gtk3::Window->new('popup') ;
$window->set_decorated(0) ;
$window->set_keep_above(1) ;
$window->set_title('Epitaph Tiny Calendar') ;
#$window->set_default_size(200, 200) ;
$window->signal_connect( destroy => sub { Gtk3->main_quit } );

my ($x, $y) = split /,/,
    `xdotool getmouselocation --shell 2>/dev/null | grep -E 'X|Y' | cut -d= -f2 | paste -sd "," -`
    || (0, 0) ;
$window->move($x, $y) ;

my $calendar = Gtk3::Calendar->new();
my $box = Gtk3::Box->new('vertical', 0);
$box->set_can_focus(1);
$box->grab_focus();

# Adding a Close button
my $close_button = Gtk3::Button->new_with_label('Close');
$close_button->signal_connect(clicked => sub {
    Gtk3->main_quit;
});


$box->add($calendar);
$box->pack_end($close_button, 0, 0, 0);

$window->add($box);


$window->signal_connect(key_press_event => sub {
    my ($widget, $event) = @_;
    if ($event->keyval == Gtk3::Gdk::KEY_Escape) {
        Gtk3->main_quit;
        return 1;
    }
    return 0;
});

$window->signal_connect(delete_event => sub { Gtk3->main_quit });
$window->show_all;

Gtk3->main;
