use std::env;
use std::fs::{read_to_string, read_dir};
use std::process::{exit, Command, Stdio};
use std::time::{Duration, Instant};
use std::thread;

/* Enum used to handle notification status */
#[derive(PartialEq)]
enum NotificationStatus {
    NotNotified,
    LowBatteryNotified,
    VeryLowBatteryNotified,
}

fn main() {
    if already_running() {
        eprintln!("Another instance of this program is already running.");
        exit(1);
    }

    /* Command Line Arguments hanlder */
    let args: Vec<String> = env::args().collect();

    if args.len() > 2 {
        eprintln!("Too many arguments! Only one argument is allowed.\
                   That argument is --help");
        exit(1);
    }

    if args.len() > 1 && args[1] == "--help" {
        println!("Battery Notify - Epitaph's built-in power manager\n");
        println!("Usage: battery-notify [OPTION]");
        println!("Options:");
        println!("--help: Print this message");
        exit(0);
    }  else if args.len() > 1 {
        println!("Unknown argument or number of arguments!");
        exit(1);
    }

    /* ===== CONFIG VALUES ===== */
    const BATTERY_PATH: &str = "/sys/class/power_supply/BAT0";
    const MAX_CHARGE: u8 = 95; // Used to indicate max battery charge
    const LOW: u8 = 20; // Used to indicate a low battery
    const CRITICAL: u8 = 5; // Used to indicate a critically low battery
    const DEAD: u8 = 2; // A practically dead battery

    const SLEEP_TIME: u64 = 10; // Time (in seconds) to wait

    const DEAD_ACTION: &'static str = "dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 \"org.freedesktop.login1.Manager.Suspend\" boolean:true"; // Action to take in case we hit "dead"

    let mut notified = NotificationStatus::NotNotified; // DO NOT CHANGE THIS
    let mut timer = Instant::now();

    /* ===== END CONFIG VALUES ===== */

    loop {
        let elapsed = timer.elapsed();

        if elapsed >= Duration::from_secs(SLEEP_TIME.into()) {
            timer = Instant::now();
        } else {
            thread::sleep(Duration::from_secs(SLEEP_TIME.into()) - elapsed);
            continue;
        }

        let battery: u8 = if let Ok(capacity) = read_to_string(format!("{}/capacity", BATTERY_PATH)) {
            capacity.trim().parse().unwrap()
        } else {
            eprintln!("Failed to read battery capacity!");
            exit(1);
        };

        let status: String = read_to_string(format!("{}/status", BATTERY_PATH))
            .expect("ERROR: Cannot read battery capacity")
            .trim()
            .to_string();

        match status.as_str() {
            "Discharging" => {
                if (battery > CRITICAL) && (battery <= LOW) && notified != NotificationStatus::LowBatteryNotified {
                    bat_notify(
                        "Low Battery!",
                        "Connect to power to avoid losing data",
                        "--icon=battery-low",
                    );
                    notified = NotificationStatus::LowBatteryNotified;
                } else if battery <= CRITICAL {
                    bat_notify(
                        "Very Low Battery!",
                        "Connect to power immediately!",
                        "--icon=battery-low",
                    );
                    notified = NotificationStatus::VeryLowBatteryNotified;
                } else if battery <= DEAD {
                    bat_notify(
                        "Battery is about to die!",
                        "suspending gracefully to avoid data loss",
                        "--icon=battery-low",
                    );
                    notified = NotificationStatus::VeryLowBatteryNotified;
                    // Suspend computer
                    Command::new(DEAD_ACTION)
                       .stdout(Stdio::null())
                       .stderr(Stdio::null())
                       .status()
                       .expect("Could not suspend system");
                }
            }

            "Charging" | "Unknown" => {
                if battery >= MAX_CHARGE && notified != NotificationStatus::NotNotified {
                    bat_notify(
                        "Fully Charged",
                        "Unplug to preserve battery life",
                        "--icon=battery",
                    );
                notified = NotificationStatus::NotNotified;
                } else {
                    notified = NotificationStatus::NotNotified;
                }
            }

            "Full" => {
                if battery == 100 && notified != NotificationStatus::NotNotified {
                    bat_notify(
                        "Battery Full",
                        "Already 100%, please unplug",
                        "--icon=battery",
                    );
                    notified = NotificationStatus::NotNotified;
                }
            }
            _ => panic!("Battery status not known"),
        }
    }
}

fn bat_notify(msg: &str, ext: &str, icon: &str) {
    Command::new("notify-send")
        .arg(msg)
        .arg(ext)
        .arg(icon)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .expect("Could not run notify-send");
}


fn already_running() -> bool {
    if let Ok(entries) = read_dir("/proc") {
        for entry in entries {
            if let Ok(entry) = entry {
                if let Ok(name) = entry.file_name().into_string() {
                    if name.starts_with("battery-notify") {
                        return true;
                    }
                }
            }
        }
    }
    false
}
