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
            return "...";
        } elsif ($info =~ /tag title (.+)/) {
            return $1;
        }
        return "...";
    };

    # Immediate song update on start
    my $current_song = $get_song->();
    $callback->("%{F#f38ba8} %{F#74c7ec}[%{F#cdd6f4} $current_song %{F#74c7ec}] %{F#313244} %{F#74c7ec}󰒮 %{F#a6e3a1}󰐎 %{F#f9e2af}󰒭%{F#cdd6f4}");
    $last_song = $current_song;

    # Update at regular intervals.
    my $timer = AnyEvent->timer(
        after => 0,
        interval => 1, # check every second
        cb => sub {
            my $current_song = $get_song->();
            if ($current_song ne $last_song) {
                $callback->(" [ $current_song ]  󰒮 󰐎 󰒭");
                $last_song = $current_song;
            }
        }
    );

    # Return the timer to keep it alive
    return $timer;
}

1;
