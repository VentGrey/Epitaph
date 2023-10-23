package DateModule;

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
      interval=>1,
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
