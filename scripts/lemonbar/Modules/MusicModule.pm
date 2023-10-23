package MusicModule;

use v5.36;
use AnyEvent;
use AnyEvent::Handle;
use IPC::Open3;

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
    $callback->("%{F#f38ba8} %{F#74c7ec}[%{F#cdd6f4} $current_song %{F#74c7ec}] %{F#313244}%{F#89b4fa}%{F#f9e2af}m%{F#cba6f7}u%{F#f38ba8}	s%{F#cdd6f4}%{F#cdd6f4}");
    $last_song = $current_song;

    # Update at regular intervals.
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 1, # check every second
        cb => sub {
            my $current_song = $get_song->();
            if ($current_song ne $last_song) {
                $callback->("%{A:perl ~/.config/leftwm/themes/Epitaph/scripts/cmuscontrol.pl:}%{F#f38ba8} %{F#74c7ec}%{A}[%{F#cdd6f4} $current_song %{F#74c7ec}] %{F#313244}%{F#89b4fa}%{#Ff38ba8}m%{F#cba6f7}u%{F#f38ba8}	s%{F#cdd6f4}%{F#cdd6f4}");
                $last_song = $current_song;
            }
        }
    );

    # Return the timer to keep it alive
    return $timer;
}

1;
