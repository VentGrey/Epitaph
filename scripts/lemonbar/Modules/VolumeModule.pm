package VolumeModule;

use v5.36;
use AnyEvent;
use AnyEvent::Handle;

use IPC::Open3;

=head1 NAME

VolumeModule - Consult and format a volume string. Report every second.

=head1 DESCRIPTION

This module relies on pactl subscribe to monitor volume changes.

=head1 METHODS

=head2 listen_state

Gets and formats the current date, finally, it registers
a callback to process changes.

=cut


sub listen_volume {
    my $callback = shift;

    # Command to get volume updates in real-time
    my @cmd = ('pactl', 'subscribe');

    my ($wtr, $rdr, $err)  = (undef, undef, undef);
    my $pid = open3($wtr, $rdr, $err, @cmd);

    my $last_output;  # to store the last output and prevent processing duplicates

    my $update_volume = sub {
        my $volume = `pamixer --get-volume`;
        chomp $volume;

        my $mute = `pamixer --get-mute`;
        chomp $mute;

        if ($mute eq 'true') {
            return "%{F#74c7ec}󰖁%{F#cdd6f4} Muted";
        } elsif ($volume == 0) {
            return "%{F#89dceb}󰕿%{F#cdd6f4} 0";
        } elsif ($volume < 50) {
            return "%{F#a6e3a1}󰖀%{F#cdd6f4} $volume";
        } else {
            return "%{F#f9e2af}󰕾%{F#cdd6f4} $volume";
        }
    };

    # Immediate volume update on start
    $callback->($update_volume->());

    my $handle;
    $handle = AnyEvent::Handle->new(
        fh => $rdr,
        on_read => sub {
            $handle->push_read(line => sub {
                my $current_output = $_[1];
                if (($current_output =~ /sink/ || $current_output =~ /change/ || $current_output =~ /cambiar/)
                    && (!defined $last_output || $current_output ne $last_output)) {
                    $callback->($update_volume->());
                    $last_output = $current_output;
                }
            });
        },
        on_error => sub {
            warn "Error with pactl: $!";
            $handle->destroy;
            close $wtr;  # Cerrar el proceso pactl
            close $rdr;
        }
    );

    # Return the handle to keep it alive
    return $handle;
}
1;
