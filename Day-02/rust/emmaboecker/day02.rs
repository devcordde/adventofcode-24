pub fn main() {
    let input = include_str!("day02.txt");

    let reports = input.lines();

    let reports = reports
        .map(|report| {
            report
                .split_whitespace()
                .map(|x| x.parse::<i32>().unwrap())
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    let part1 = reports
        .iter()
        .map(|levels| check_levels(levels, 0))
        .filter(|x| *x)
        .count();

    println!("Part 1: {}", part1);

    let part2 = reports
        .iter()
        .map(|levels| check_levels(levels, 1))
        .filter(|x| *x)
        .count();

    println!("Part 2: {}", part2);
}

fn check_levels(levels: &[i32], errors: usize) -> bool {
    let mut ascending = levels.to_vec();
    ascending.sort();
    let mut descending = ascending.clone();
    descending.reverse();

    let fail_diff = levels
        .windows(2)
        .any(|x| (x[0] - x[1]).abs() > 3 || x[0] == x[1]);

    if levels != ascending && levels != descending || fail_diff {
        if errors == 0 {
            return false;
        }
        for (i, _) in levels.iter().enumerate() {
            let mut new_levels = levels.to_vec();
            new_levels.remove(i);
            if check_levels(&new_levels, errors - 1) {
                return true;
            }
        }
        false
    } else {
        true
    }
}
