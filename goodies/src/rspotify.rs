use mpris::{Metadata, Player, PlayerFinder};

fn main() {
    // Get a new mpris player
    let player: Player = PlayerFinder::new()
        .expect("Unable to connect to D-Bus")
        .find_active()
        .expect("No player");


    let metadata: Metadata = player.get_metadata()
                                   .expect("Unable to get current player metadata");

    // Get track id to see if this comes from spotify
    let id: String = metadata.track_id().to_string();

    if id.contains("spotify:track:") {
        let artist: String = metadata.artists().unwrap()[0].to_string();
        let song: String = metadata.title().unwrap().to_string();

        let mut status: String = song + " - " + &artist;

        if status.len() > 80 {
            status.truncate(80);
            status.push_str("...");
        }
        println!("{}", status.to_string());
    } else {
        println!("");
    }
}
