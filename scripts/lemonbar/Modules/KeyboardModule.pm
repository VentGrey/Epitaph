package KeyboardModule;

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

use v5.36;
use AnyEvent;
use AnyEvent::Handle;
use IPC::Open3;

=head1 NAME

KeyboardModule - Consult and format a resulting string from the command-line utility setxkbmap.

TODO: Make this use a filewatcher that works with anyevent.

=head1 DESCRIPTION

This module uses internal Perl functions / libraries to print a formatted
keyboard layout string to the lemonbar.

=head1 METHODS

=head2 listen_keyboard

Gets and formats the current keyboard distribution, finally, it registers
a callback to process changes.

=cut

sub listen_keyboard {
    my $callback = shift;

    my $last_layout;

    my $update_layout = sub {
        my $output = `setxkbmap -query`;
        if ($output =~ /layout:\s+(\w+)/) {
            return $1;
        }
        return "Unknown";
    };

    # Immediate update on start
    $callback->($update_layout->());

    # Again, for real-time updates, you might need to integrate this with other tools
    # or just update it at regular intervals.
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 5,
        cb => sub {
            my $current_layout = $update_layout->();
            if (!defined $last_layout || $current_layout ne $last_layout) {
                $callback->("%{F#f2cdcd}󰌌%{F#cdd6f4} $current_layout");
                $last_layout = $current_layout;
            }
        }
    );

    # Return the timer to keep it alive
    return $timer;
}

1;
