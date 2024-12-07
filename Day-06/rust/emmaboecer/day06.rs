use std::collections::HashSet;

type Position = (usize, usize, Direction);
#[derive(PartialEq, Clone, Copy)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl Direction {
    fn position_change(&self) -> (i32, i32) {
        match *self {
            Direction::Up => (0, -1),
            Direction::Down => (0, 1),
            Direction::Left => (-1, 0),
            Direction::Right => (1, 0),
        }
    }

    fn turn_right(&self) -> Direction {
        match *self {
            Direction::Up => Direction::Right,
            Direction::Right => Direction::Down,
            Direction::Down => Direction::Left,
            Direction::Left => Direction::Up,
        }
    }
}

pub fn main() {
    let input = include_str!("../../input/day06.txt");

    let matrix = input
        .lines()
        .map(|x| x.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let start_position = matrix
        .iter()
        .flatten()
        .enumerate()
        .find(|(_, x)| x == &&'^');

    let start_position = match start_position {
        Some((i, _)) => (i % matrix[0].len(), i / matrix[0].len(), Direction::Up),
        None => panic!("No starting position found"),
    };
    let mut position = start_position;
    let mut path: HashSet<(usize, usize)> = HashSet::from([(position.0, position.1)]);

    while let Some((x, y, direction)) = find_next_position(&matrix, position) {
        position = (x, y, direction);
        path.insert((x, y));
    }

    println!("Part 1: {:?}", path.len());

    let mut loops = vec![];
    for position in path {
        if loops.contains(&position) {
            continue;
        }
        if runs_loops(
            &matrix,
            start_position,
            (position.0, position.1, Direction::Up),
        ) {
            loops.push(position);
        }
    }
    
    println!("Part 2: {:?}", loops.len());
}

fn find_next_position(matrix: &[Vec<char>], position: Position) -> Option<Position> {
    let (x, y, direction) = position;
    let (dx, dy) = direction.position_change();
    let (nx, ny) = (x as i32 + dx, y as i32 + dy);
    if nx < 0 || ny < 0 || ny >= matrix.len() as i32 || nx >= matrix[0].len() as i32 {
        None
    } else if matrix[ny as usize][nx as usize] == '#' {
        return Some((x, y, direction.turn_right()));
    } else {
        return Some((nx as usize, ny as usize, direction));
    }
}

fn runs_loops(matrix: &[Vec<char>], position: Position, obstacle: Position) -> bool {
    let mut position = position;
    let mut visited = vec![position];
    let mut matrix = matrix.to_vec();
    matrix[obstacle.1][obstacle.0] = '#';
    loop {
        if let Some(next_position) = find_next_position(&matrix, position) {
            if visited.contains(&next_position) {
                return true;
            }
            visited.push(next_position);
            position = next_position;
        } else {
            return false;
        }
    }
}
