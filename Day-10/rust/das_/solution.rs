use std::fs;

fn main() {
    let lines = fs::read_to_string("input.txt").unwrap();
    let grid: Vec<Vec<u32>> = lines.lines()
        .map(|line| line.chars().map(|char| char.to_digit(10).unwrap()).collect())
        .collect();

    let mut part1 = 0;
    let mut part2 = 0;

    for row in 0..grid.len() {
        for column in 0..grid.first().unwrap().len() {
            let mut result = solve(&grid, row as i32, column as i32, 0);
            part2 += result.len();

            result.sort_unstable();
            result.dedup();
            part1 += result.len();
        }
    }

    println!("Part 1: {part1}");
    println!("Part 2: {part2}");
}

fn solve(grid: &Vec<Vec<u32>>, row: i32, column: i32, n: u32) -> Vec<(i32, i32)> {
    let max_row = grid.len() as i32;
    let max_column = grid.first().unwrap().len() as i32;

    if row < 0 || row >= max_row || column < 0 || column >= max_column {
        return vec![]
    }

    if grid[row as usize][column as usize] != n {
        return vec![];
    }

    if n == 9 {
        return vec![(row, column)]
    }

    let mut vec = vec![];
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
        vec.append(&mut solve(grid, row + dx, column + dy, n + 1))
    }

    vec
}
