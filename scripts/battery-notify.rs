use std::env;
use std::fs::read_to_string;
use std::process::{exit, Command, Stdio};
use std::{thread, time};

fn main() {
    // Command Line Arguments hanlder
    let args: Vec<String> = env::args().collect();
    let mut is_debug: bool = false;

    if args.is_empty() {
        drop(args);
    } else if args.len() > 1 && args[1] == "--help" {
        println!("Battery Notify - Epitaph's built-in power manager\n");
        println!("Usage: battery-notify <options>");
        println!("Options:");
        println!("--help: Print this message");
        println!("--backlight: Allow epitaph to control your backlight (WIP)");
        println!("--debug: Run with debug info printed to stderr");
        exit(0);
    } else if args.len() > 1 && args[1] == "--debug" {
        println!("Debugging mode activated! Will start logging to stderr...\n");
        is_debug = true;
    } else if args.len() > 1 {
        println!("Unknown argument or number of arguments!");
        exit(1);
    }

    /* ===== CONFIG VALUES ===== */
    const max_charge: u8 = 98; // Used to indicate max battery charge
    const low: u8 = 15; // Used to indicate a low battery
    const critical: u8 = 5; // Used to indicate a critically low battery
    const dead: u8 = 2; // A practically dead battery

    const sleep_time: u8 = 10; // Time (in seconds) to wait

    const dead_action: &'static str = "dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 \"org.freedesktop.login1.Manager.Suspend\" boolean:true"; // Action to take in case we hit "dead"

    let mut notified: bool = false; // DO NOT CHANGE THIS

    /* ===== END CONFIG VALUES ===== */

    loop {
        // NOTE: Some systems might use a different battery than "BAT1", change this
        // according to your system battery. If unsure run:
        // $ ls /sys/class/power_supply

        let battery: u8 = read_to_string("/sys/class/power_supply/BAT1/capacity")
            .expect("ERROR: Cannot read battery capacity")
            .trim()
            .to_string()
            .parse::<u8>()
            .unwrap();

        let status: String = read_to_string("/sys/class/power_supply/BAT1/status")
            .expect("ERROR: Cannot read battery capacity")
            .trim()
            .to_string();

        match status.as_str() {
            "Discharging" => {
                if (battery > critical) && (battery <= low) && notified == false {
                    bat_notify(
                        "Low Battery!",
                        "Connect to power to avoid losing data",
                        "--icon=battery-low",
                    );
                    notified = true;
                } else if battery <= critical {
                    bat_notify(
                        "Very Low Battery!",
                        "Connect to power immediately!",
                        "--icon=battery-low",
                    );
                    notified = true;
                } else if battery <= dead {
                    bat_notify(
                        "Battery is about to die!",
                        "suspending gracefully to avoid data loss",
                        "--icon=battery-low",
                    );
                    notified = true;
                    // Suspend computer
                    Command::new(dead_action)
                        .stdout(Stdio::null())
                        .stderr(Stdio::null())
                        .status()
                        .expect("Could not suspend system");
                }
            }
            "Charging" | "Unknown" => {
                if battery >= max_charge && notified == false {
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
            eprintln!("Maximum charge value: {}%", max_charge);
            eprintln!("Battery is considered low when it reaches: {}%", low);
            eprintln!(
                "Battery is considered critical when it reaches: {}%",
                critical
            );
            eprintln!("Battery is considered dead when it reaches: {}%", dead);
            eprintln!(
                "If the battery reaches 'dead' level, the system will {} itself",
                dead_action
            );
            eprintln!("The user was notified: {}", notified);
            eprintln!("--- Next iteration will run in {} seconds", sleep_time);
            eprintln!("========================");
        }

        thread::sleep(time::Duration::from_secs(sleep_time.into()));
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
