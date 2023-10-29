package BatteryModule;

use v5.36;
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

    my $check_and_notify = sub {
        my ($status, $capacity) = @_;
        my $icon = "";
        my %battery_icons = (
                             'Charging' => { 100 => '󰄌%{F#cdd6f4w}', default => '%{F#cdd6f4w}' },
                             'Discharging' => {
                                               0   => '%{F#f38ba8}󰂃%{F#cdd6f4w}',   # Suspend now!
                                               10  => '%{F#f38ba8}󰁺%{F#cdd6f4w}',   # Save your files panicking
                                               20  => '󰁻%{F#cdd6f4w}',              # Things can go ugly if you ignore these
                                               30  => '%{F#eba0ac}󰁼%{F#cdd6f4w}',   # Hey, wanna recharge?
                                               40  => '%{F#fab387}󰁽%{F#cdd6f4w}',   # I mean, just a few more minutes...right
                                               50  => '%{F#f9e2af}󰁾%{F#cdd6f4w}',
                                               60  => '%{F#f9e2af}󰁿%{F#cdd6f4w}',
                                               70  => '%{F#f9e2af}󰂀%{F#cdd6f4w}',
                                               80  => '%{F#a6e3a1}󰂁%{F#cdd6f4w}',
                                               90  => '%{F#94e2d5}󰂂%{F#cdd6f4w}',    # Advertencia
                                               default => '%{F#b4befe}󰂑%{F#cdd6f4w}',
                                              },
                             'Full' => '%{F#a6e3a1}󱈏%{F#cdd6f4w}',
                            );

        if (exists $battery_icons{$status}) {
          if (ref($battery_icons{$status}) eq 'HASH') {
            $icon = $battery_icons{$status}{$capacity} || $battery_icons{$status}{default};
          } else {
            $icon = $battery_icons{$status};
          }
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

            print "DEBUG: Status: $status, Capacity: $capacity\n"; # Debug line

            $check_and_notify->($status, $capacity);
        },
    );
    return $timer; # Return the timer to keep it alive
}

1;
