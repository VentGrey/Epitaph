package DateModule;

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
use Inline C => 'DATA';

=head1 NAME

DateModule - Consult and format a localtime string. Report every second.

=head1 DESCRIPTION

This module uses inlined C to print a formatted date string to the lemonbar.

=head1 METHODS

=head2 listen_state

Gets and formats the current date, finally, it registers
a callback to process changes.

=cut

sub listen_date {
  my $callback = shift;
  my $timer = AnyEvent->timer(
    after => 0,
    interval => 1,
    cb => sub {
      my $date = get_formatted_date();
      $callback->("%{F#89b4fa}󰃭 $date%{F#cdd6f4}");
    }
  );
  return $timer;
}

1;
__DATA__
__C__

#include <time.h>

char* get_formatted_date() {
    static char date_str[100];
    time_t t = time(NULL);
    struct tm *tm_info = localtime(&t);
    
    strftime(date_str, sizeof(date_str), "%A %d %b (%H:%M)", tm_info);
    return date_str;
}
