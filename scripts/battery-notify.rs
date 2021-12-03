fn main() {

    /* ===== CONFIG VALUES ===== */
    let max_charge: u8 = 98; // Used to indicate max battery charge
    let low: u8 = 15; // Used to indicate a low battery
    let critical: u8 = 5; // Used to indicate a critically low battery
    let dead: u8 = 2; // A practically dead battery

    let mut notified: bool = false; // DO NOT CHANGE THIS

    let sleep_time: u8 = 5; // Time (in seconds) to wait

    let dead_action: &str = "suspend"; // Action to take in case we hit "dead"

    // NOTE: Some systems might use a different battery than "BAT1", change this
    // according to your system battery. If unsure run:
    // $ ls /sys/class/power_supply

    let battery: u8 =
        std::fs::read_to_string("/sys/class/power_supply/BAT1/capacity")
        .expect("ERROR: Cannot read battery capacity").trim().to_string()
        .parse::<u8>().unwrap();

    let status: String =
        std::fs::read_to_string("/sys/class/power_supply/BAT1/status")
        .expect("ERROR: Cannot read battery capacity").trim().to_string();

    /* ===== END CONFIG VALUES ===== */


    loop {
        match status.as_str() {
            "Discharging" => {
                if battery > critical && battery <= low && notified == false {
                    bat_notify("Low Battery!",
                               "Connect to power to avoid losing data",
                               "--icon=battery-low");
                    notified = true;
                } else if battery <= critical {
                    bat_notify("Very Low Battery!",
                               "Connect to power immediately!",
                               "--icon=battery-low");
                    notified = true;
                } else if battery <= dead {
                    bat_notify("Battery is about to die!",
                               "suspending gracefully to avoid data loss",
                               "--icon=battery-low");
                    notified = true;
                    // Suspend computer
                    std::process::Command::new("systemctl")
                        .arg(dead_action)
                        .stdout(std::process::Stdio::null())
                        .stderr(std::process::Stdio::null())
                        .status()
                        .expect("Could not suspend system");
                }
            },
            "Charging" | "Unknown" => {
                if battery >= max_charge && notified == false {
                    bat_notify("Fully Charged",
                               "Unplug to preserve battery life",
                               "--icon=battery");
                    notified = true;
                } else {
                    notified = false;
                }
            },
            "Full" => {
                bat_notify("Battery Full",
                           "Already 100%, please unplug",
                           "--icon=battery");
                notified = true;
            }
            _ => panic!("Battery status not known"),
        }
        std::thread::sleep(std::time::Duration::from_secs(sleep_time.into()));
    }
}

fn bat_notify(msg: &'static str, ext: &'static str, icon: &'static str) {
    std::process::Command::new("notify-send")
        .arg(msg)
        .arg(ext)
        .arg(icon)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("Could not run notify-send");
}
