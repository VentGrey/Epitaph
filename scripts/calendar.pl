use strict;
use warnings;

use Gtk3 '-init';
use DateTime;
use Time::Local;

my $reminders_file = 'reminders.txt';

my $window = Gtk3::Window->new('popup');
$window->set_decorated(0);
$window->set_keep_above(1);
$window->set_title('Epitaph Tiny Calendar');
$window->set_default_size(300, 300);

my ($x, $y) = split /,/, `xdotool getmouselocation --shell 2>/dev/null | grep -E 'X|Y' | cut -d= -f2 | paste -sd "," -` || (0, 0);
$window->move($x, $y);

my $calendar = Gtk3::Calendar->new();
my $box = Gtk3::Box->new('vertical', 5);
$box->set_can_focus(1);
$box->grab_focus();
$box->add($calendar);

my $reminders_label = Gtk3::Label->new("");
$box->add($reminders_label);

my $close_button = Gtk3::Button->new_with_label('Close');
$close_button->signal_connect(clicked => sub {
    Gtk3->main_quit;
});
$box->pack_end($close_button, 0, 0, 0);

$window->add($box);

$window->signal_connect(key_press_event => sub {
    my ($widget, $event) = @_;
    if ($event->keyval == Gtk3::Gdk::KEY_Escape) {
        Gtk3->main_quit;
        return 1;
    }
    return 0;
});

$calendar->signal_connect('day-selected' => \&show_reminders_for_date);
$calendar->signal_connect('day-selected-double-click' => \&add_reminder);

$window->signal_connect(delete_event => sub { Gtk3->main_quit });
$window->show_all;

Gtk3->main;

sub add_reminder {
    my ($year, $month, $day) = $calendar->get_date;

    my $time_dialog = Gtk3::Dialog->new('Set Reminder Time', $window, 'modal',
        'gtk-ok'     => 'accept',
        'gtk-cancel' => 'cancel',
    );
    my $hour_spin = Gtk3::SpinButton->new_with_range(0, 23, 1);
    my $minute_spin = Gtk3::SpinButton->new_with_range(0, 59, 1);

    my $hbox = Gtk3::Box->new('horizontal', 5);
    $hbox->add(Gtk3::Label->new("Hour:"));
    $hbox->add($hour_spin);
    $hbox->add(Gtk3::Label->new("Minute:"));
    $hbox->add($minute_spin);

    $time_dialog->get_content_area()->add($hbox);
    $time_dialog->show_all;
    if ($time_dialog->run eq 'accept') {
        my $hour = $hour_spin->get_value_as_int();
        my $minute = $minute_spin->get_value_as_int();
        
        my $dialog = Gtk3::Dialog->new('Add reminder', $window, 'modal',
            'gtk-ok'     => 'accept',
            'gtk-cancel' => 'cancel',
        );

        my $content_area = $dialog->get_content_area();
        my $entry = Gtk3::Entry->new();
        $content_area->add($entry);
        
        $dialog->show_all;
        if ($dialog->run eq 'accept') {
            my $reminder = $entry->get_text;
            open(my $fh, '>>', $reminders_file) or die "Could not open file '$reminders_file' $!";
            print $fh "$year-$month-$day:$hour:$minute:00:$reminder\n";
            close $fh;

            # Use the 'at' command to schedule a notification
            my $datetime = DateTime->new(year => $year, month => $month + 1, day => $day, hour => $hour, minute => $minute);
            my $timestamp = $datetime->epoch();
            system("at -t ${timestamp}00 -f <(echo 'notify-send \"Reminder\" \"$reminder\"') &");
        }
        $dialog->destroy;
    }
    $time_dialog->destroy;
    show_reminders_for_date();
}

sub show_reminders_for_date {
    my ($year, $month, $day) = $calendar->get_date;
    
    open(my $fh, '<', $reminders_file) or return;
    my @reminders_for_day;
    while (my $line = <$fh>) {
        chomp $line;
        my ($date, $time, $reminder) = split /:/, $line, 3;
        if ($date eq "$year-$month-$day") {
            push @reminders_for_day, "$time: $reminder";
        }
    }
    close $fh;

    $reminders_label->set_text(join("\n", @reminders_for_day));
}
