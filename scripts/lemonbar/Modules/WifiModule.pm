package WifiModule;

use v5.36;
use AnyEvent;
use AnyEvent::Handle;
use IPC::Open3;

sub listen_wifi {
    my $callback = shift;

    my $last_status;

    my $update_wifi = sub {
        my $output = `/sbin/iwconfig wlp4s0 2>&1`;  # Usamos el path completo para iwconfig
        if ($output !~ /no wireless extensions/) {
            if ($output =~ /Bit Rate=([\d\.]+ Mb\/s)/) {
                my $bitrate = $1;
                return "%{F#cba6f7}󰤨 $bitrate%{F#cdd6f4}";  # Nerd font icon for WiFi connected with BitRate
            }
            return "%{F#cba6f7}󰤨%{F#cdd6f4}";  # Nerd font icon for WiFi connected without BitRate
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
