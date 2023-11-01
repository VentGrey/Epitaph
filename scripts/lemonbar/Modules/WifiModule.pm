package WifiModule;

use v5.36;
use AnyEvent;
use AnyEvent::Handle;
use IPC::Open3;

=head1 NAME

WifiModule - Consult and format a resulting string from the command-line utility iwconfig.

TODO: Make this use a dbus approach or a constant stream of data.

=head1 DESCRIPTION

This module dynamically tries to get the current wifi connection and signal.

=head1 METHODS

=head2 listen_wifi

Gets and formats the current network status, finally, it registers
a callback to process changes.

=cut


sub listen_wifi {
    my $callback = shift;

    my $last_status;

    my $update_wifi = sub {
        my $output = `/sbin/iwconfig wlan0 2>&1`;  # Usamos el path completo para iwconfig
        if ($output !~ /no wireless extensions/) {
            if ($output =~ /Bit Rate=([\d\.]+ Mb\/s)/) {
                my $bitrate = $1;
                return "%{F#cba6f7}󰤨 $bitrate%{F#cdd6f4}";  # Nerd font icon for WiFi connected with BitRate
            }
            return "%{F#cba6f7}󰤭%{F#cdd6f4}";  # Nerd font icon for WiFi connected without BitRate
        }
        return "%{F#f38ba8}󰤭%{F#cdd6f4}";  # Nerd font icon for WiFi disconnected
    };

    # Immediate update on start
    $callback->($update_wifi->());

    # Update at regular intervals.
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 5,
        cb => sub {
            my $current_status = $update_wifi->();
            if (!defined $last_status || $current_status ne $last_status) {
                $callback->($current_status);
                $last_status = $current_status;
            }
        }
    );

    # Return the timer to keep it alive
    return $timer;
}

1;
