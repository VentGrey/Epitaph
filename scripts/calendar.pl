use strict;
use warnings;

use Gtk3 '-init';
use DateTime;
use Time::Local;

my $window = Gtk3::Window->new('popup');
$window->set_decorated(0);  # No decorations
$window->set_keep_above(1);
$window->set_title('Epitaph Tiny Calendar');
$window->set_default_size(300, 250);
my ($x, $y) = split /,/, `xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d= -f2 | paste -sd "," -`;
$window->move($x, $y);

my $calendar = Gtk3::Calendar->new();
my $box = Gtk3::Box->new('vertical', 5);
$box->set_can_focus(1);
$box->grab_focus();
$box->add($calendar);

# Adding a Close button
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

$calendar->signal_connect('day-selected-double-click' => \&add_reminder);

$window->signal_connect(delete_event => sub { Gtk3->main_quit });
$window->show_all;

Gtk3->main;

sub add_reminder {
    my ($year, $month, $day) = $calendar->get_date;

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
        my $time = timelocal(0, 0, 0, $day, $month, $year);
        system("at now + $time seconds -f <(echo 'notify-send \"Reminder\" \"$reminder\"') &");
    }

    $dialog->destroy;
}
