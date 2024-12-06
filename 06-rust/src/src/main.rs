
const FILENAME: &str = "example.txt";



#[derive(Clone, Debug, Copy)]
enum Cell {
    Obstacle,
    Guard,
    Empty,
    Visited,
}


fn read_file(filename: &str) -> std::io::Result<()> {

    let grid = [[Cell::Empty; 50]; 50];

    let s: Vec<&str> = std::fs::read_to_string(filename)?.lines().collect();

    Ok(())

}


fn main() {





}
