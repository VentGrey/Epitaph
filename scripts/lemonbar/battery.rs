use std::fs::read_to_string;

fn main() {
    // This variable defines an unsigned integer read from the reporting file
    // in the /sys/class/power_supply directory present in Linux systems.
    //
    // If you wish to change the monitores battery make sure to change the
    // "BAT1" text for your system battery. In most cases it's only
    // BAT0 or BAT1. Dual Battery systems are not supported.
    let battery: u8 = read_to_string("/sys/class/power_supply/BAT1/capacity")
        .expect("ERROR: Cannot read battery capacity")
        .trim()
        .to_string()
        .parse::<u8>()
        .unwrap();

    // This variable defines a string representing the current battery status
    // read from the reporting file in the /sys/class/power_supply directory
    // present in Linux systems.
    //
    // If you wish to change the monitores battery make sure to change the
    // "BAT1" text for your system battery. In most cases it's only
    // BAT0 or BAT1. Dual Battery systems are not supported.
    let bat_stat: String = read_to_string("/sys/class/power_supply/BAT1/status")
        .expect("ERROR: Cannot read battery status")
        .trim()
        .to_string();

    // Status icon to show in the bar
    let status: char;

    // Battery icon printed to the bar
    let icon: char;

    // Change your desired thresholds + icons in this match statement
    // The default values are:
    // 0% - 10% =   (Empty Battery)
    // 11% - 25% =   (Low Battery)
    // 26% - 50% =   (Medium Battery)
    // 51% - 75% =   (Almost Full Battery)
    // 76% - 100% =  (Full Battery)
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

    // Change your desired status icons here. Depending on your system you
    // might want to change these, as desktop computers and both laptops
    // with working and non working batters might behave differently.
    //
    // The default values are:
    //
    // "Charging" "Unknown" and "Not Charging": 
    // "Discharging": 
    // "Full": 
    // If for some strange reason your battery status is anything else that
    // isn't defined in the sysfs-class-power linux ABI. This will print a
    //  symbol and you should really take a look at your installation or
    // stop using BSD.
    if bat_stat == "Charging" || bat_stat == "Unknown" || bat_stat == "Not charging" {
        status = '';
    } else if bat_stat == "Discharging" {
        status = '';
    } else if bat_stat == "Full" {
        status = '';
    } else {
        status = '';
    }

    // Change your final results print format in here
    // The default look should be like this:
    //    28%
    // Assuming your battery has that capacity and it's charging.
    print!("{} {} {}%", icon, status, battery);
}
