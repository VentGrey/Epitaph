fn main() {
    let battery: u8 =
        std::fs::read_to_string("/sys/class/power_supply/BAT1/capacity")
        .expect("ERROR: Cannot read battery capacity").trim().to_string()
        .parse::<u8>().unwrap();

    let bat_stat: String =
        std::fs::read_to_string("/sys/class/power_supply/BAT1/status")
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
    print!("{} {}%", status, battery);
}
