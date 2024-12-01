// https://github.com/emmaboecker/aoc-2024/blob/main/src/bin/day01.rs

pub fn main() {
    let input = include_str!("day01.txt");

    let lines = input
        .lines()
        .map(|line| line.split_whitespace())
        .collect::<Vec<_>>();

    let mut lhs = Vec::with_capacity(lines.len());
    let mut rhs = Vec::with_capacity(lines.len());
    for mut split in lines {
        lhs.push(split.next().unwrap().parse::<i32>().unwrap());
        rhs.push(split.next().unwrap().parse::<i32>().unwrap());
    }
    lhs.sort();
    rhs.sort();

    let sum: i32 = lhs
        .iter()
        .zip(rhs.iter())
        .map(|(lhs, rhs)| (lhs - rhs).abs())
        .sum();

    println!("Part 1: {}", sum);

    let mut sum = 0;
    for number in lhs {
        let mut found = 0;
        let index = rhs.binary_search(&number);
        if let Ok(index) = index {
            found += 1;
            for leftnumber in rhs[..index].iter().rev() {
                if leftnumber == &number {
                    found += 1;
                } else {
                    break;
                }
            }
            for rightnumber in &rhs[index + 1..] {
                if rightnumber == &number {
                    found += 1;
                } else {
                    break;
                }
            }
        }
        sum += number * found;
    }

    println!("Part 2: {}", sum);
}
