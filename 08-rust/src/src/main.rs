const FILENAME: &str = "example.txt";
// const FILENAME: &str = "input.txt";


fn read_file(filename: &str) -> std::io::Result<String> {
    Ok(std::fs::read_to_string(filename)?)
}




#[derive(Clone, Copy, Debug, PartialEq)]
enum Element {
    File(u64),
    Empty
}

impl std::fmt::Display for Element {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use Element as E;
        match self {
            E::File(value) => write!(f, "{}", value),
            E::Empty       => write!(f, "."),
        }
    }
}




fn parse_input(mut input: String) -> Vec<Element> {
    input.pop(); // Remove newline

    let mut result = Vec::<Element>::new();
    let mut id     = 0;
    let mut mode   = true; // if true add file, else add empty space

    for c in input.chars() {

        let digit: u32 = c.to_digit(10).unwrap();

        for _ in 0..digit {
            result.push(
                if mode {
                    Element::File(id)
                } else {
                    Element::Empty
                }
            );
        }

        mode = !mode;
        if mode {
            id += 1;
        }

    }

    result

}


fn vec_print(v: &Vec<Element>) {
    for item in v {
        print!("{}", item)
    }
    println!();
}


fn remove_empty_space(input: &mut Vec<Element>) {

    let mut empty_counter = 0;

    for item in input.iter() {
        if *item == Element::Empty {
            empty_counter += 1;
        }
    }

    let mut non_empty = input.clone();
    non_empty.retain(|item| *item != Element::Empty);

    while let Some(pos) = input.iter().position(|item| *item == Element::Empty) {
        let m = input.get_mut(pos).unwrap();
        let last = non_empty.pop().unwrap();
        *m = last;
    }

    for _ in 0..empty_counter {
        input.pop().unwrap();
    }

}

fn get_checksum(input: &Vec<Element>) -> u64 {

    let mut checksum = 0;

    for (index, item) in input.into_iter().enumerate() {
        use Element as E;
        match item {
            E::File(id) => checksum += id * index as u64,
            E::Empty => {}
        }
    }

    checksum

}




/* PART TWO */
fn remove_empty_space_by_blocks(input: &mut Vec<Element>) {

    let copy = input.clone();
    // let last = input.pop().unwrap();

    while let Some(pos) = input
        .iter()
        .position(|item| *item == Element::Empty) {




    }

}



fn main() -> std::io::Result<()> {

    let f: String = read_file(FILENAME)?;
    let mut parsed: Vec<Element> = parse_input(f);

    // vec_print(&parsed);
    // remove_empty_space(&mut parsed);
    remove_empty_space_by_blocks(&mut parsed);
    // vec_print(&parsed);

    let checksum = get_checksum(&mut parsed);
    println!("checksum: {}", checksum);




    Ok(())

}
