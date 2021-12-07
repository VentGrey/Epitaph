use std::fs::read_to_string;

fn main() {
    let bat_now: u8 =
        read_to_string("/sys/class/power_supply/BAT1/charge_now")
        .expect("ERROR: Cannot read battery charge")
        .trim()
        .to_string()
        .parse::<u8>()
        .unwrap();

    let bat_full: u8 =
        read_to_string("/sys/class/power_supply/BAT1/charge_full")
        .expect("ERROR: Cannot read battery full charge")
        .trim()
        .to_string()
        .parse::<u8>()
        .unwrap();

    let bat_stat: String =
        read_to_string("/sys/class/power_supply/BAT1/status")
        .expect("ERROR: Cannot read battery status").trim().to_string();

    let status: char;

    if bat_stat == "Charging" || bat_stat == "Unknown" {
        status = '';
    } else if bat_stat == "Discharging" {
        status = '';
    } else if bat_stat == "Full" {
        status = '';
    } else {
        status = '';
    }
    print!("{} {}%", status, (bat_now / (bat_full / 100)));
}
