use std::env;
use std::fs::read_to_string;
use std::process::{exit, Command, Stdio};
use std::{thread, time};

fn main() {
    /* Check if another battery-notify process is already running */
    let output = Command::new("pgrep")
        .arg("-f")
        .arg("battery-notify")
        .output()
        .expect("failed to execute process");

    if output.stdout.len() > 1 {
        println!("Another battery-notify process is already running");
        exit(0);
    }

    /* Command Line Arguments hanlder */
    let args: Vec<String> = env::args().collect();

    // Only allow one argument to be passed
    if args.len() > 2 {
        eprintln!("Too many arguments! Only one argument is allowed.\
                   That argument can be --help, --backlight or --debug");
        exit(1);
    }

    let is_debug: bool = args.get(1).map_or(false, |x| {
        if x == "--debug" || x == "-d" {
            println!("Debugging mode activated! Will start logging to stderr...\n");
            true
        } else {
            false
        }
    });

    if args.len() > 1 && args[1] == "--help" {
        println!("Battery Notify - Epitaph's built-in power manager\n");
        println!("Usage: battery-notify <options>");
        println!("Options:");
        println!("--help: Print this message");
        println!("--debug: Run with debug info printed to stderr");
        exit(0);
    }  else if args.len() > 1 {
        println!("Unknown argument or number of arguments!");
        exit(1);
    }

    /* ===== CONFIG VALUES ===== */
    const MAX_CHARGE: u8 = 98; // Used to indicate max battery charge
    const LOW: u8 = 15; // Used to indicate a low battery
    const CRITICAL: u8 = 5; // Used to indicate a critically low battery
    const DEAD: u8 = 2; // A practically dead battery

    const SLEEP_TIME: u8 = 10; // Time (in seconds) to wait

    const DEAD_ACTION: &'static str = "dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 \"org.freedesktop.login1.Manager.Suspend\" boolean:true"; // Action to take in case we hit "dead"

    let mut notified: bool = false; // DO NOT CHANGE THIS

    /* ===== END CONFIG VALUES ===== */

    loop {
        // NOTE: Some systems might use a different battery than "BAT0", change this
        // according to your system battery. If unsure run:
        // $ ls /sys/class/power_supply

        let battery: u8 = if let Ok(capacity) = read_to_string("/sys/class/power_supply/BAT0/capacity") {
            capacity.trim().parse().unwrap()
        } else {
            eprintln!("Failed to read battery capacity!");
            exit(1);
        };

        let status: String = read_to_string("/sys/class/power_supply/BAT0/status")
            .expect("ERROR: Cannot read battery capacity")
            .trim()
            .to_string();

        match status.as_str() {
            "Discharging" => {
                if (battery > CRITICAL) && (battery <= LOW) && notified == false {
                    bat_notify(
                        "Low Battery!",
                        "Connect to power to avoid losing data",
                        "--icon=battery-low",
                    );
                    notified = true;
                } else if battery <= CRITICAL {
                    bat_notify(
                        "Very Low Battery!",
                        "Connect to power immediately!",
                        "--icon=battery-low",
                    );
                    notified = true;
                } else if battery <= DEAD {
                    bat_notify(
                        "Battery is about to die!",
                        "suspending gracefully to avoid data loss",
                        "--icon=battery-low",
                    );
                    notified = true;
                    // Suspend computer
                    Command::new(DEAD_ACTION)
                        .stdout(Stdio::null())
                        .stderr(Stdio::null())
                        .status()
                        .expect("Could not suspend system");
                }
            }
            "Charging" | "Unknown" => {
                if battery >= MAX_CHARGE && notified == false {
                    bat_notify(
                        "Fully Charged",
                        "Unplug to preserve battery life",
                        "--icon=battery",
                    );
                    notified = true;
                } else {
                    notified = false;
                }
            }
            "Full" => {
                if battery == 100 && notified == false {
                    bat_notify(
                        "Battery Full",
                        "Already 100%, please unplug",
                        "--icon=battery",
                    );
                    notified = true;
                }
            }
            _ => panic!("Battery status not known"),
        }

        if is_debug {
            eprintln!("==== LOG ITERATION ====");
            eprintln!("Battery level: {}%", battery);
            eprintln!("Battery status: {}", status);
            eprintln!("Maximum charge value: {}%", MAX_CHARGE);
            eprintln!("Battery is considered low when it reaches: {}%", LOW);
            eprintln!(
                "Battery is considered critical when it reaches: {}%",
                CRITICAL
            );
            eprintln!("Battery is considered dead when it reaches: {}%", DEAD);
            eprintln!(
                "If the battery reaches 'dead' level, the system will {} itself",
                DEAD_ACTION
            );
            eprintln!("The user was notified: {}", notified);
            eprintln!("--- Next iteration will run in {} seconds", SLEEP_TIME);
            eprintln!("========================");
        }

        thread::sleep(time::Duration::from_secs(SLEEP_TIME.into()));
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
