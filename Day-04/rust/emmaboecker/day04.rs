pub fn main() {
    let input = include_str!("day04.txt");

    let matrix = input
        .lines()
        .map(|x| x.chars().collect::<Vec<_>>())
        .collect::<Vec<Vec<_>>>();

    let mut part1 = vec![];
    for (iy, y) in matrix.iter().enumerate() {
        for (ix, x) in y.iter().enumerate() {
            if x == &'X' {
                part1.extend(find_word(&matrix, "XMAS", (ix, iy)));
            }
        }
    }

    println!("Part 1: {:?}", part1.len());

    let mut part2 = vec![];
    for (iy, y) in matrix.iter().enumerate() {
        for (ix, x) in y.iter().enumerate() {
            if x == &'A' {
                if let Some(found) = find_x(&matrix, (ix, iy)) {
                    part2.push(found);
                }
            }
        }
    }

    println!("Part 2: {:?}", part2.len());
}

type Position = (usize, usize);
type PositionChange = (i32, i32);

const POSITION_CHANGES: [PositionChange; 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
];

fn find_word(matrix: &[Vec<char>], word: &str, start: Position) -> Vec<Vec<Position>> {
    let mut found = vec![];
    'search: for (change_x, change_y) in POSITION_CHANGES {
        let mut inner_found = vec![start];
        let mut start = start;
        for searching in word[1..].chars() {
            let y = start.1 as i32 + change_y;
            let x = start.0 as i32 + change_x;
            if x < 0 || y < 0 || y >= matrix.len() as i32 || x >= matrix[0].len() as i32 {
                continue 'search;
            }
            let char = matrix.get(y as usize).and_then(|y| y.get(x as usize));

            if let Some(char) = char {
                if *char == searching {
                    inner_found.push((x as usize, y as usize));
                    start = (x as usize, y as usize);
                } else {
                    continue 'search;
                }
            }
            if inner_found.len() == word.len() {
                found.push(inner_found);
                break;
            }
        }
    }

    found
        .into_iter()
        .filter(|x| x.len() == word.len())
        .collect()
}

const X_POSITION_CHANGES: [PositionChange; 4] = [(-1, 1), (1, 1), (-1, -1), (1, -1)];

fn find_x(matrix: &[Vec<char>], start: Position) -> Option<Vec<Position>> {
    let mut found = vec![start];

    let positions = X_POSITION_CHANGES
        .iter()
        .map(|(x, y)| search(matrix, start, x, y))
        .collect::<Vec<_>>();

    if !positions.iter().all(|x| x.is_some()) {
        return None;
    }

    let positions = positions.into_iter().flatten().collect::<Vec<_>>();

    let s = positions
        .iter()
        .filter(|(_, char)| char == &'S')
        .collect::<Vec<_>>();

    if !((s.len() == 2 && (s[0].0 .0 == s[1].0 .0 || s[0].0 .1 == s[1].0 .1))
        && positions.iter().filter(|(_, char)| char == &'M').count() == 2)
    {
        return None;
    }

    found.extend(positions.iter().map(|(pos, _)| *pos));

    if found.len() == 5 {
        Some(found)
    } else {
        None
    }
}

fn search(
    matrix: &[Vec<char>],
    start: Position,
    x_change: &i32,
    y_change: &i32,
) -> Option<(Position, char)> {
    let y = (start.1 as i32 + x_change) as usize;
    let x = (start.0 as i32 + y_change) as usize;
    let char = matrix.get(y).and_then(|y| y.get(x));

    char.map(|char| ((x, y), *char))
}
