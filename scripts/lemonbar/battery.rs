fn main() {
    let battery: u8 = std::fs::read_to_string("/sys/class/power_supply/BAT1/capacity")
        .expect("ERROR: Cannot read battery capacity")
        .trim()
        .to_string()
        .parse::<u8>()
        .unwrap();

    let bat_stat: String = std::fs::read_to_string("/sys/class/power_supply/BAT1/status")
        .expect("ERROR: Cannot read battery status")
        .trim()
        .to_string();

    // Status icon to show in the bar
    let status: char;

    // Battery icon printed to the bar
    let icon: char;

    match battery {
        0..=10 => {
            icon = '';
        }
        11..=25 => {
            icon = '';
        }
        26..=50 => {
            icon = '';
        }
        51..=75 => {
            icon = '';
        }
        76..=100 => {
            icon = '';
        }
        _ => panic!("Couldn't assign an icon to the battery charge number!"),
    }

    if bat_stat == "Charging" || bat_stat == "Unknown" {
        status = '';
    } else if bat_stat == "Discharging" {
        status = '';
    } else if bat_stat == "Full" {
        status = '';
    } else {
        status = '';
    }

    // Print the final results
    print!("{} {} {}%", icon, status, battery);
}
