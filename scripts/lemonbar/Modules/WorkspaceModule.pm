#!/usr/bin/perl
package WorkspaceModule;

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


use strict;
use warnings;

use AnyEvent;
use AnyEvent::Handle;

use IPC::Open3;


=head1 NAME

WorkspaceModule - Consult leftwm-state to get the current tag and focused window
No external liquid files were needed.

=head1 DESCRIPTION

This module uses leftwm-state to get the current workspace state.

=head1 METHODS

=head2 listen_state

Inits leftwm-state with the provided liquid template arguments and registers
a callback to process changes.

=cut

sub listen_leftwm_state {
    my $callback = shift;

    # Get leftwm state
    my @cmd = (
        'leftwm-state', '-w0', '-s',
        "
{% for tag in workspace.tags %}
%{A:leftwm-command 'GoToTag {{ tag.index | plus:'1' }} false':}
{% if tag.mine %}
 %{F#74c7ec}{{tag.name | lstrip | rstrip}}%{F#cdd6f4w}
{% elsif tag.visible %}
 {{tag.name | lstrip | rstrip}}
{% elsif tag.busy %}
 %{F#f9e2af}{{tag.name | lstrip | rstrip}}%{F#cdd6f4w}
{% else %}
 %{F#cdd6f4w}{{tag.name | lstrip | rstrip}}%{F#cdd6f4w}
{% endif %}
%{A}
{% endfor %}
 %{F#313244}%{F#cdd6f4w} %{F#a6e3a1} {{ workspace.layout }}%{F#cdd6f4w} %{F#313244}%{F#cdd6f4w} {{window_title | truncate: 30 }}"
        );

    my ($wtr, $rdr, $err)  = (undef, undef, undef);
    my $pid = open3($wtr, $rdr, $err, @cmd);

    my $handle;
    $handle = AnyEvent::Handle->new(
        fh => $rdr,
        on_read => sub {
            $handle->push_read(line => sub {
                $callback->($_[1]);
            });
        },
        on_error => sub {
            warn "Error with leftwm-state: $!";
            $handle->destroy;
        }
    );

    return $handle;
}

1;
