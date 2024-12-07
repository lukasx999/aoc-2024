
const FILENAME: &str = "example.txt";
// const FILENAME: &str = "input.txt";


type Grid<T> = Vec<Vec<T>>;



#[derive(Debug, Clone, Copy, Default, PartialEq)]
enum Cell {
    #[default] Empty,
    Obstacle,
    GuardUp,
    GuardDown,
    GuardRight,
    GuardLeft,
    Visited,
}


impl From<char> for Cell {
    fn from(value: char) -> Self {
        match value {
            '.' => Self::Empty,
            '#' => Self::Obstacle,
            'X' => Self::Visited,
            '^' => Self::GuardUp,
            '<' => Self::GuardLeft,
            '>' => Self::GuardRight,
            'v' => Self::GuardDown,
            _   => panic!(),
        }
    }
}


fn read_file(filename: &str) -> std::io::Result<Grid<Cell>> {

    let grid: Grid<Cell> = std::fs::read_to_string(filename)?
        .lines()
        .map(|line| {
            line.to_owned().chars().map(|c| {
                Cell::from(c)
            }).collect()
        }).collect();

    Ok(grid)

}





#[derive(Default, Clone, Copy, Debug)]
enum Direction {
    #[default] North,
    East,
    South,
    West,
}

#[derive(Debug, Clone, Copy)]
struct Guard {
    pub row: usize,
    pub column: usize,
    pub direction: Direction,
}

fn find_guard(grid: &Grid<Cell>) -> Option<Guard> {

    for (y, row) in grid.into_iter().enumerate() {
        for (x, item) in row.into_iter().enumerate() {

            match item {
                Cell::GuardUp    => return Some(Guard { row: y, column: x, direction: Direction::North }),
                Cell::GuardDown  => return Some(Guard { row: y, column: x, direction: Direction::South }),
                Cell::GuardRight => return Some(Guard { row: y, column: x, direction: Direction::East  }),
                Cell::GuardLeft  => return Some(Guard { row: y, column: x, direction: Direction::West  }),
                _ => {}
            }

        }
    }

    None

}


fn get_guard_cell_ahead<'a>(guard: &Guard, grid: &'a Grid<Cell>) -> Option<&'a Cell> {
    use Direction as D;

    if guard.row >= grid.len()-1 {
        return None;
    }

    if guard.column >= grid[0].len()-1 {
        return None;
    }

    match guard.direction {
        D::North => Some(&grid[guard.row-1][guard.column]),
        D::East  => Some(&grid[guard.row][guard.column+1]),
        D::South => Some(&grid[guard.row+1][guard.column]),
        D::West  => Some(&grid[guard.row][guard.column-1]),
    }

}

fn guard_turn_right(guard: &mut Guard) {
    use Direction as D;

    match guard.direction {
        D::North => { guard.direction = D::East  }
        D::East  => { guard.direction = D::South }
        D::South => { guard.direction = D::West  }
        D::West  => { guard.direction = D::North }
    }

}

fn guard_move(guard: &mut Guard) {
    use Direction as D;

    match guard.direction {
        D::North => guard.row    -= 1,
        D::East  => guard.column += 1,
        D::South => guard.row    += 1,
        D::West  => guard.column -= 1,
    }

}

fn guard_update(grid: &mut Grid<Cell>, counter: &mut u32) -> Option<()> {
    use Direction as D;

    let mut guard = find_guard(grid).unwrap();
    let next_cell = get_guard_cell_ahead(&guard, grid)?;

    if *next_cell == Cell::Obstacle {
            guard_turn_right(&mut guard);
    }

    if *next_cell != Cell::Visited {
        *counter += 1; 
    }

    grid[guard.row][guard.column] = Cell::Visited;
    guard_move(&mut guard);
    grid[guard.row][guard.column] = match guard.direction {
        D::North => Cell::GuardUp,
        D::South => Cell::GuardDown,
        D::West  => Cell::GuardLeft,
        D::East  => Cell::GuardRight,
    };

    Some(())

}

fn print_grid(grid: &Grid<Cell>) {

    println!();
    for row in grid {
        for column in row {
            use Cell as C;

            print!("{}",
                match column {
                    C::Empty      => '.',
                    C::Obstacle   => '#',
                    C::Visited    => 'X',
                    C::GuardUp    => '^',
                    C::GuardLeft  => '<',
                    C::GuardRight => '>',
                    C::GuardDown  => 'v',
                }
            );

        }
        println!();
    }
    println!();

}



fn main() -> std::io::Result<()> {

    let mut grid: Grid<Cell> = read_file(FILENAME)?;

    let mut counter = 1;

    loop {
        print_grid(&grid);
        let res = guard_update(&mut grid, &mut counter);
        if res == None {
            break;
        }
    }




    println!("count: {}", counter);




    Ok(())

}
