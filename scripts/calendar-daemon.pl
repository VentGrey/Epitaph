#!/usr/bin/env perl
use strict;
use warnings;
use DateTime;
use Getopt::Long;

# Command line option for the age of reminders to delete
my $max_age = 0;  # Default: Don't delete any reminders
GetOptions("max-age=i" => \$max_age);

my $reminders_file = "$ENV{HOME}/.config/leftwm/themes/Epitaph/calendar/reminders";

open(my $fh, '<', $reminders_file) or die "Could not open file '$reminders_file' $!";
my @lines = <$fh>;
close $fh;

open($fh, '>', $reminders_file) or die "Could not open file '$reminders_file' for writing $!";

for my $line (@lines) {
    chomp $line;
    my ($date, $time, $reminder) = split /:/, $line;

    my ($year, $month, $day) = split /-/, $date;
    my ($hour, $minute, $second) = split /:/, $time;

    my $now = DateTime->now;
    my $reminder_datetime = DateTime->new(
        year   => $year,
        month  => $month,
        day    => $day,
        hour   => $hour,
        minute => $minute,
        second => $second
    );

    my $duration = $reminder_datetime->subtract_datetime($now);
    my $days_old = $duration->in_units('days');

    # Delete reminders older than the specified max age
    if ($max_age > 0 && $days_old > $max_age) {
        next;
    }

    # Write back to file if the reminder is not too old
    print $fh "$line\n";

    # Schedule the notification if it's in the future
    if ($reminder_datetime > $now) {
        my $at_time = sprintf("%02d:%02d %02d/%02d/%04d", $hour, $minute, $day, $month, $year);
        my $command = "echo \"notify-send 'Reminder' '$reminder'\" | at $at_time";
        system($command);
    }
}

close $fh;
