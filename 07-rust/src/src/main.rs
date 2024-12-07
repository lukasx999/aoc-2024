const FILENAME: &str = "example.txt";


#[derive(Debug, Clone)]
struct Equation {
    pub test_value: u64,
    pub numbers:    Vec<u64>,
}

impl Equation {

    pub fn new(input: &str) -> Self {

        let (test_value, numbers) = input.split_once(":").unwrap();
        let mut numbers = numbers.to_owned();
        numbers.remove(0);

        let numbers: Vec<u64> = numbers
            .split(" ")
            .map(|number| number.parse().unwrap())
            .collect();

        Self {
            test_value: test_value.parse().unwrap(),
            numbers,
        }

    }

    pub fn parse(&self) -> Option<u64> {

        let mut nums: Vec<u64> = self.numbers.clone();
        nums.reverse();



        Some(self.test_value)
    }

}



fn parse_input(filename: &str) -> std::io::Result<Vec<Equation>> {

    Ok(std::fs::read_to_string(filename)?
        .lines()
        .map(|line| {
            Equation::new(line)
        }).collect())

}






fn main() -> std::io::Result<()> {

    let equations: Vec<Equation> = parse_input(FILENAME)?;
    let mut threads: Vec<std::thread::JoinHandle<Option<u64>>> = Vec::new();

    for equation in equations {

        let handle = std::thread::spawn(move || {
            equation.parse()
        });

        threads.push(handle);

    }

    let mut sum = 0;

    for thread in threads {
        if let Some(num) = thread.join().unwrap() {
            sum += num;
        }
    }

    println!("sum: {sum}");




    Ok(())

}
