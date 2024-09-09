package MusicModule;

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

MusicModule - Consult and format a resulting string from the command-line utility cmus listener.

TODO: Make this use the cmus socket or a constant stream.

=head1 DESCRIPTION

This module dynamically tries to get the current cmus playing song.

=head1 METHODS

=head2 listen_cmus

Gets and formats the current cmus playing song, finally, it registers
a callback to process changes.

=cut


sub listen_cmus {
    my $callback = shift;

    my $last_song = '';

    my $get_song = sub {
        my $info = `cmus-remote -Q`;
        if ($info =~ /status stopped/) {
            return "%{F#cdd6f4}...%{F#74c7ec}";
        } elsif ($info =~ /tag title (.+)/) {
            return $1;
        }
        return "%{F#cdd6f4}...%{F#74c7ec}";
    };

    # Immediate song update on start
    my $current_song = $get_song->();
    $callback->("%{F#f38ba8} %{F#74c7ec}[%{F#cdd6f4} $current_song %{F#74c7ec}] %{F#313244}%{F#89b4fa}%{F#cdd6f4}");
    $last_song = $current_song;

    # Update at regular intervals.
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 1, # check every second
        cb => sub {
            my $current_song = $get_song->();
            if ($current_song ne $last_song) {
                $callback->("%{F#f38ba8} %{F#74c7ec}[%{F#cdd6f4} $current_song %{F#74c7ec}] %{F#313244}%{F#89b4fa}%{F#cdd6f4}");
                $last_song = $current_song;
            }
        }
    );

    # Return the timer to keep it alive
    return $timer;
}

1;
