
const FILENAME: &str = "example.txt";


type Grid<T> = Vec<Vec<T>>;



#[derive(Debug, Clone, Copy, Default)]
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
    pub x: usize,
    pub y: usize,
    pub direction: Direction,
}

fn find_guard(grid: &Grid<Cell>) -> Option<Guard> {

    for (x, row) in grid.into_iter().enumerate() {
        for (y, item) in row.into_iter().enumerate() {

            match item {
                Cell::GuardUp    => return Some(Guard { x, y, direction: Direction::North }),
                Cell::GuardDown  => return Some(Guard { x, y, direction: Direction::South }),
                Cell::GuardRight => return Some(Guard { x, y, direction: Direction::East  }),
                Cell::GuardLeft  => return Some(Guard { x, y, direction: Direction::West  }),
                _ => {}
            }

        }
    }

    None

}


fn get_guard_cell_ahead<'a>(guard: &Guard, grid: &'a Grid<Cell>) -> Option<&'a Cell> {

    use Direction as D;

    if guard.x > grid.len()-1 {
        return None;
    }

    if guard.y > grid[0].len()-1 {
        return None;
    }

    match guard.direction {
        D::North => Some(&grid[guard.x][guard.y+1]),
        D::East =>  Some(&grid[guard.x+1][guard.y]),
        D::South => Some(&grid[guard.x][guard.y-1]),
        D::West =>  Some(&grid[guard.x-1][guard.y]),
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
        D::North => guard.y += 1,
        D::East  => guard.x += 1,
        D::South => guard.y -= 1,
        D::West  => guard.x -= 1,
    }

}

fn guard_update(grid: &mut Grid<Cell>) -> Option<()> {
    use Direction as D;

    let mut guard = find_guard(grid).unwrap();
    let next_cell = get_guard_cell_ahead(&guard, grid)?;

    match next_cell {
        Cell::Obstacle => {
            guard_turn_right(&mut guard);
        }
        _ => {}
    }

    grid[guard.x][guard.y] = Cell::Visited;
    guard_move(&mut guard);
    grid[guard.x][guard.y] =
        match guard.direction {
            D::North => Cell::GuardUp,
            D::South => Cell::GuardDown,
            D::West => Cell::GuardLeft,
            D::East => Cell::GuardRight,
        };

    Some(())

}



fn main() -> std::io::Result<()> {

    let mut grid: Grid<Cell> = read_file(FILENAME)?;

    dbg!(find_guard(&grid));
    guard_update(&mut grid);
    dbg!(find_guard(&grid));




    Ok(())

}
