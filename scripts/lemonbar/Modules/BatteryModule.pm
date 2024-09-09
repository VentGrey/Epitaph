package BatteryModule;

# Copyright (C) [2023-2024] [VentGrey]
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

use v5.40;
use AnyEvent;
use File::ChangeNotify;

=head1 NAME

BatteryModule - Consult and format a battery string from the Linux filesystem.

TODO: Make this use a filewatcher that works with anyevent

=head1 DESCRIPTION

This module uses internal Perl functions / libraries to print a formatted
battery string to the lemonbar it notifies battery changes.

=head1 METHODS

=head2 listen_state

Gets and formats the current battery status, finally, it registers
a callback to process changes.

=cut

sub listen_battery {
    my $battery = shift // "BAT0";
    my $callback = shift;

    my $status_path = "/sys/class/power_supply/$battery/status";
    my $capacity_path = "/sys/class/power_supply/$battery/capacity";

    my $watcher = File::ChangeNotify->instantiate_watcher(
        directories => [ "/sys/class/power_supply/$battery/" ],
        filter      => qr/^(?:$status_path|$capacity_path)$/,
       );

    my $previous_output = '';

    my $check_and_notify = sub($status, $capacity) {
        my $icon = "";
        if ($status eq 'Charging') {
            if ($capacity == 100) {
                $icon = '󰄌%{F#cdd6f4w}';
            } else {
                $icon = '%{F#cdd6f4w}';
            }
        } elsif ($status eq 'Discharging' || $status eq 'Not charging') {
            if ($capacity <= 5) {
                $icon = '%{F#f38ba8}󰂃%{F#cdd6f4w}'; # Suspend now!
            } elsif ($capacity <= 10) {
                $icon = '%{F#f38ba8}󰁺%{F#cdd6f4w}'; # Save your files panicking
            } elsif ($capacity <= 20) {
                $icon = '%{F#eba0ac}󰁻%{F#cdd6f4w}'; # Things can go ugly if you ignore these
            } elsif ($capacity <= 30) {
                $icon = '%{F#eba0ac}󰁼%{F#cdd6f4w}'; # Hey, wanna recharge?
            } elsif ($capacity <= 40) {
                $icon = '%{F#fab387}󰁽%{F#cdd6f4w}' # I mean, just a few more minutes...right/
            } elsif ($capacity <= 50) {
                $icon = '%{F#f9e2af}󰁾%{F#cdd6f4w}';
            } elsif ($capacity <= 60) {
                $icon = '%{F#f9e2af}󰁿%{F#cdd6f4w}';
            } elsif ($capacity <= 70) {
                $icon = '%{F#f9e2af}󰂀%{F#cdd6f4w}';
            } elsif ($capacity <= 80) {
                $icon = '%{F#a6e3a1}󰂁%{F#cdd6f4w}';
            } elsif ($capacity <= 90) {
                $icon = '%{F#94e2d5}󰂂%{F#cdd6f4w}';
            } else {
                $icon = '%{F#b4befe}󰂑%{F#cdd6f4w}';
            }
        } elsif ($status eq 'Full') {
            $icon = '%{F#a6e3a1}󱈏%{F#cdd6f4w}';
        }

        my $output = "$icon $capacity";
        if ($output ne $previous_output) {
            $callback->($output);
            $previous_output = $output;
          }
      };

    # Non-blocking check for new events
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 5, # Check every 5 seconds
        cb => sub {
            open my $status_fh, '<', $status_path or die "Cannot open $status_path: $!";
            my $status = <$status_fh>;
            chomp $status;
            close $status_fh;

            open my $capacity_fh, '<', $capacity_path or die "Cannot open $capacity_path: $!";
            my $capacity = <$capacity_fh>;
            chomp $capacity;
            close $capacity_fh;

            print "DEBUG: Status: $status, Capacity: $capacity\n";

            $check_and_notify->($status, $capacity);
        },
    );
    return $timer; # Return the timer to keep it alive
}

1;
