use std::error::Error;
use std::collections::HashMap;

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

fn parse_rules(rules: &str) -> Vec<(i32, i32)> {

    let rules: Vec<(i32, i32)> = rules.lines().map(|pair| {
        let (l, r) = pair.split_once("|").unwrap();
        let l      = l.parse::<i32>().unwrap();
        let r      = r.parse::<i32>().unwrap();
        (l, r)
    }).collect();

    rules

}



fn construct_lookuptable(rules: Vec<(i32, i32)>) -> HashMap<i32, Vec<i32>> {

    let mut lut: HashMap<i32, Vec<i32>> = HashMap::new();

    for pair in rules {
        if let Some(old_value) = lut.insert(pair.0, vec![pair.1]) {
            let mut old_value = old_value.clone();
            lut.get_mut(&pair.0).unwrap().append(&mut old_value);
        }
    }

    lut

}


fn main() -> Result<(), Box<dyn Error>> {

    let (rules, input) = read_file(FILENAME)?;
    let rules = parse_rules(rules.as_str());
    let input = parse_input(input.as_str());

    // TODO: loop over input sequence
    // TODO: accumulate items before current in vector
    // TODO: create hashtable of rules
    // TODO: hashtable loopup with current item as key
    // TODO: if value is in buffer -> incorrect else correct

    let lut = construct_lookuptable(rules);
    println!("{:#?}", lut);



    let mut buf: Vec<i32> = Vec::new();

    for line in input {
        let mut contains = true;

        for item in line {

            let l: Vec<i32> = match lut.get(&item) {
                Some(l) => l.clone(),
                None => continue,
            };

            for i in &l {
                if buf.contains(i) {
                    contains = false;
                }
            }

            buf.push(item);

        }
        if !contains {
            println!("incorrect");
        }
    }




    Ok(())

}
