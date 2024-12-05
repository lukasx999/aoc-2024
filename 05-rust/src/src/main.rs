use std::error::Error;

const FILENAME: &str = "example.txt";


fn read_file(filename: &str) -> std::io::Result<(String, String)> {
    let file: String = std::fs::read_to_string(filename)?;
    let (rules, input) = file.split_once("\n\n").unwrap();
    Ok((rules.to_owned(), input.to_owned()))
}


fn parse_input(input: &str) -> Vec<Vec<i32>> {

    let input: Vec<Vec<i32>> = input.lines().map(|line| {
        line.split(",").map(|num| {
            num.parse::<i32>().unwrap()
        }).collect()
    }).collect();

    input

}

fn parse_rules(rules: &str) -> Result<Vec<(i32, i32)>, Box<dyn Error>> {

    let rules: Vec<(i32, i32)> = rules.lines().map(|pair| {
        let (l, r) = pair.split_once("|").unwrap();
        let l      = l.parse::<i32>().unwrap();
        let r      = r.parse::<i32>().unwrap();
        (l, r)
    }).collect();

    Ok(rules)

}


fn main() -> Result<(), Box<dyn Error>> {

    let (rules, input) = read_file(FILENAME)?;
    let rules = parse_rules(rules.as_str())?;
    let input = parse_input(input.as_str());
    println!("{:#?}", input);

    Ok(())

}
