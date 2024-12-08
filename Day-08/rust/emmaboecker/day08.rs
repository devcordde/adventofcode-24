use std::collections::{HashMap, HashSet};

type Position = (usize, usize);

pub fn main() {
    let input = include_str!("day08.txt");

    let matrix = input
        .lines()
        .map(|line| line.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let mut unique_antennas: HashMap<char, Vec<Position>> = HashMap::new();
    for (ix, chars) in matrix.iter().enumerate() {
        for (iy, c) in chars.iter().enumerate() {
            if *c != '.' {
                if let Some(list) = unique_antennas.get_mut(c) {
                    list.push((ix, iy));
                } else {
                    unique_antennas.insert(*c, vec![(ix, iy)]);
                }
            }
        }
    }

    let mut antinodes = HashSet::new();
    for locations in unique_antennas.values() {
        for (x1, y1) in locations {
            for (x2, y2) in locations {
                if (y1, x1) == (y2, x2) {
                    continue;
                }

                let (x1, y1, x2, y2) = (*x1 as i32, *y1 as i32, *x2 as i32, *y2 as i32);
                let (dx, dy) = (x2 - x1, y2 - y1);
                let positions = [(x1 - dx, y1 - dy), (x2 + dx, y2 + dy)];

                for (ax, ay) in positions.iter() {
                    if check_bounds(&matrix, *ax, *ay) {
                        antinodes.insert((*ax as usize, *ay as usize));
                    }
                }
            }
        }
    }

    println!("Part 1: {:?}", antinodes.len());

    let mut antinodes = HashSet::new();
    for locations in unique_antennas.values() {
        for (x1, y1) in locations {
            for (x2, y2) in locations {
                if (y1, x1) == (y2, x2) {
                    continue;
                }

                let (x1, y1, x2, y2) = (*x1 as i32, *y1 as i32, *x2 as i32, *y2 as i32);
                let (dx, dy) = (x2 - x1, y2 - y1);
                let mut positions = [
                    (x1 - dx, y1 - dy),
                    (x2 + dx, y2 + dy),
                    (x1 + dx, y1 + dy),
                    (x2 - dx, y2 - dy),
                ];

                for position in positions.iter_mut() {
                    while check_bounds(&matrix, position.0, position.1) {
                        antinodes.insert((position.0 as usize, position.1 as usize));
                        position.0 += dx;
                        position.1 += dy;
                    }
                }
            }
        }
    }

    println!("Part 2: {:?}", antinodes.len());
}

fn check_bounds(matrix: &[Vec<char>], x: i32, y: i32) -> bool {
    x >= 0 && x < matrix[0].len() as i32 && y >= 0 && y < matrix.len() as i32
}
