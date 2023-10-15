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

use strict;
use warnings;

use Gtk3 '-init';
use DateTime;
use Time::Local;

# Ensure only one instance is running
my $pid = `pgrep -f $0`;
chomp $pid;
if ($pid && $pid != $$) {
    die "Another instance of this script is already running.";
}

reprogram_reminders();

my $reminders_file = "$ENV{HOME}/.config/leftwm/themes/Epitaph/calendar/reminders";

my $reminders_dir = "$ENV{HOME}/.config/leftwm/themes/Epitaph/calendar";
unless (-d $reminders_dir) {
    mkdir $reminders_dir or die "Failed to create directory: $!";
}

my $window = Gtk3::Window->new('popup');
$window->set_decorated(0);
$window->set_keep_above(1);
$window->set_title('Epitaph Tiny Calendar');
$window->set_default_size(300, 300);

my ($x, $y) = split /,/, `xdotool getmouselocation --shell 2>/dev/null | grep -E 'X|Y' | cut -d= -f2 | paste -sd "," -` || (0, 0);
$window->move($x, $y);

my $calendar = Gtk3::Calendar->new();
$calendar->signal_connect('map' => \&show_reminders_for_date);

my $reminders_label = Gtk3::Label->new("");

my $delete_button = Gtk3::Button->new_with_label('Delete Reminders');
$delete_button->signal_connect(clicked => \&delete_reminders);

my $close_button = Gtk3::Button->new_with_label('Close');
$close_button->signal_connect(clicked => sub {
    Gtk3->main_quit;
});

my $buttons_box = Gtk3::Box->new('horizontal', 5);
$buttons_box->pack_start($delete_button, 1, 1, 0);
$buttons_box->pack_end($close_button, 1, 1, 0);

my $box = Gtk3::Box->new('vertical', 5);
$box->set_can_focus(1);
$box->grab_focus();
$box->add($calendar);
$box->add($reminders_label);
$box->add($buttons_box);

$window->add($box);

$window->signal_connect(key_press_event => sub {
    my ($widget, $event) = @_;
    if ($event->keyval == Gtk3::Gdk::KEY_Escape) {
        Gtk3->main_quit;
        return 1;
    }
    return 0;
});

$calendar->signal_connect('day-selected' => \&show_reminders_for_date);
$calendar->signal_connect('day-selected-double-click' => \&add_reminder);

$window->signal_connect(delete_event => sub { Gtk3->main_quit });
$window->show_all;

Gtk3->main;

sub add_reminder {
    my ($year, $month, $day) = $calendar->get_date;

    my $time_dialog = Gtk3::Dialog->new('Set Reminder Time', $window, 'modal',
        'gtk-ok'     => 'accept',
        'gtk-cancel' => 'cancel',
    );
    my $hour_spin = Gtk3::SpinButton->new_with_range(0, 23, 1);
    my $minute_spin = Gtk3::SpinButton->new_with_range(0, 59, 1);

    my $hbox = Gtk3::Box->new('horizontal', 5);
    $hbox->add(Gtk3::Label->new("Hour:"));
    $hbox->add($hour_spin);
    $hbox->add(Gtk3::Label->new("Minute:"));
    $hbox->add($minute_spin);

    $time_dialog->get_content_area()->add($hbox);
    $time_dialog->show_all;
    if ($time_dialog->run eq 'accept') {
        my $hour = $hour_spin->get_value_as_int();
        my $minute = $minute_spin->get_value_as_int();
        
        my $dialog = Gtk3::Dialog->new('Add reminder', $window, 'modal',
            'gtk-ok'     => 'accept',
            'gtk-cancel' => 'cancel',
        );

        my $content_area = $dialog->get_content_area();
        my $entry = Gtk3::Entry->new();
        $content_area->add($entry);
        
        $dialog->show_all;
        if ($dialog->run eq 'accept') {
            my $reminder = $entry->get_text;
            open(my $fh, '>>', $reminders_file) or die "Could not open file '$reminders_file' $!";
            # En la función add_reminder
            print $fh sprintf("%04d-%02d-%02d:%02d:%02d:00:%s\n", $year, $month, $day, $hour, $minute, $reminder);
            close $fh;

            # Calculate the time remaining until the reminder
            my $now = DateTime->now;
            my $reminder_datetime = DateTime->new(
                year   => $year,
                month  => $month,
                day    => $day,
                hour   => $hour,
                minute => $minute
            );
            my $duration = $reminder_datetime->subtract_datetime($now);
            my $seconds_until_reminder = $duration->in_units('seconds');

            # Use the 'at' command to schedule a notification
            if ($seconds_until_reminder > 0) {
                my $notification_command = "notify-send 'Reminder' '$reminder'";

                run_as_daemon(sub {
                    sleep($seconds_until_reminder);
                    system("notify-send 'Reminder' '$reminder'");
                });
            }
            my $message_dialog = Gtk3::MessageDialog->new(
                $window, 
                'destroy-with-parent',
                'info', 
                'ok',
                "Recordatorio añadido con éxito para el $day/$month/$year a las $hour:$minute"
           );
            $message_dialog->run;
            $message_dialog->destroy;
        }
        $dialog->destroy;
    }
    $time_dialog->destroy;

    # Show the reminders for the selected date
    show_reminders_for_date();
}


sub show_reminders_for_date {
    my ($year, $month, $day) = $calendar->get_date;
    
    open(my $fh, '<', $reminders_file) or return;
    my @reminders_for_day;
    while (my $line = <$fh>) {
        chomp $line;
        my ($date, $time, $reminder) = split /:/, $line, 3;
        if ($date eq "$year-$month-$day") {
            push @reminders_for_day, "$time: $reminder";
        }
    }
    close $fh;

    $reminders_label->set_text(join("\n", @reminders_for_day));
}

sub delete_reminders {
    my $dialog = Gtk3::Dialog->new('Delete Reminders', $window, 'modal',
        'Delete All'    => 'delete_all',
        'Delete Old'    => 'delete_old',
        'gtk-cancel'    => 'cancel',
    );
    
    $dialog->set_default_size(150, 100);
    my $label = Gtk3::Label->new("Do you want to delete all reminders or only old ones?");
    $dialog->get_content_area()->add($label);
    $dialog->show_all;

    my $response = $dialog->run();
    if ($response eq 'delete_all') {
        open(my $fh, '>', $reminders_file) or die "Could not open file '$reminders_file' $!";
        close $fh;
    } elsif ($response eq 'delete_old') {
        my @current_reminders;
        my $current_datetime = DateTime->now();
        open(my $fh, '<', $reminders_file) or die "Could not open file '$reminders_file' $!";
        while (my $line = <$fh>) {
            chomp $line;
            my ($date, $time, $reminder) = split /:/, $line, 3;
            my ($year, $month, $day) = split /-/, $date;
            my ($hour, $minute, $second) = split /:/, $time;
            my $reminder_datetime = DateTime->new(year => $year, month => $month, day => $day, hour => $hour, minute => $minute, second => $second);
            push @current_reminders, $line if $reminder_datetime >= $current_datetime;
        }
        close $fh;
        
        open($fh, '>', $reminders_file) or die "Could not open file '$reminders_file' $!";
        print $fh join("\n", @current_reminders);
        close $fh;
    }
    $dialog->destroy;
}

# Spawn in another process.
sub run_as_daemon {
    my ($command) = @_;

    my $pid = fork();
    if ($pid) {
        # En el proceso padre
        exit 0;
    } else {
        # En el proceso hijo
        setsid();
        exec($command);
    }    
}

# Function to reprogram reminders at startup
sub reprogram_reminders {
    my $reminders_file = "$ENV{HOME}/.config/leftwm/themes/Epitaph/calendar/reminders";

    open(my $fh, '<', $reminders_file) or die "Could not open file '$reminders_file' $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($date, $time, $reminder) = split /:/, $line;

        my ($year, $month, $day) = split /-/, $date;
        my ($hour, $minute, $second) = split /:/, $time;

        my $now = DateTime->now;
        my $reminder_datetime = DateTime->new(
            year   => $year,
            month  => $month,
            day    => $day,
            hour   => $hour,
            minute => $minute,
            second => $second
        );

        my $duration = $reminder_datetime->subtract_datetime($now);
        my $seconds_until_reminder = $duration->in_units('seconds');

        if ($seconds_until_reminder > 0) {
            my $at_time = sprintf("%02d:%02d %02d/%02d/%04d", $hour, $minute, $day, $month, $year);
            my $notification_command = "| at $at_time";
            open(my $pipe, $notification_command) or die "Failed to open pipe: $!";
            print $pipe "notify-send 'Reminder' '$reminder'";
            close $pipe;
            run_as_daemon($notification_command);
        }
    }
    close $fh;
}
