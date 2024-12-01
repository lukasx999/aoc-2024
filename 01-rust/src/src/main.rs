

// const FILENAME: &str = "example.txt";
const FILENAME: &str = "input.txt";
const SEP:      &str = "   ";





fn split_columns(filename: &str) -> std::io::Result<(Vec<i32>, Vec<i32>)> {

    let input: String = std::fs::read_to_string(filename)?;
    let lines: Vec<&str> = input.lines().collect();

    let mut left:  Vec<i32> = Vec::new();
    let mut right: Vec<i32> = Vec::new();

    for pair in &lines {
        let mut split = pair.split(SEP);
        left.push(split.next().unwrap().parse().unwrap());
        right.push(split.next().unwrap().parse().unwrap());
    }

    Ok((left, right))

}


// Returns index of minimum value in vector
fn get_min(v: &Vec<i32>) -> usize {

    let x: &i32 = v.iter().min_by(|a, b| a.cmp(b)).unwrap();
    let index: usize = v.iter().position(|item| item == x).unwrap();
    index

}



/* PART ONE */
fn part_one(mut left: Vec<i32>, mut right: Vec<i32>) {

    let mut sum = 0;

    for _ in left.clone() {

        let index_x: usize = get_min(&left);
        let index_y: usize = get_min(&right);

        let x: i32 = left[index_x];
        let y: i32 = right[index_y];

        let diff = x - y;
        sum += diff.abs();

        left.remove(index_x);
        right.remove(index_y);

    }

    dbg!(sum);

}



/* PART TWO */
fn part_two(left: Vec<i32>, right: Vec<i32>) {

    let mut sum = 0;

    for i in left {

        let mut occurrences = 0;

        for x in &right {
            if *x == i {
                occurrences += 1;
            }
        }

        sum += i * occurrences;

    }

    dbg!(sum);

}


fn main() -> std::io::Result<()> {

    let (left, right): (Vec<i32>, Vec<i32>) = split_columns(FILENAME)?;

    part_one(left.clone(), right.clone());
    part_two(left, right);



    Ok(())

}
