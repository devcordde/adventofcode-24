use std::fs;

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let mut lines = input.split("\n\n");
    let patterns: Vec<&str> = lines.next().unwrap().split(", ").collect();

    let towel_combinations: Vec<u64> = lines.next().unwrap().lines()
        .map(|towel| solve(towel, &patterns))
        .collect();

    println!("Part 1: {}", towel_combinations.iter().filter(|x| **x != 0).count());
    println!("Part 2: {}", towel_combinations.iter().sum::<u64>())
}

fn solve(pattern: &str, sub_patterns: &[&str]) -> u64 {
    let length = pattern.len();
    let mut possibilities: Vec<u64> = vec![0; length + 1];
    possibilities[0] = 1;

    for i in 1..=length {
        for sub_pattern in sub_patterns {
            if i >= sub_pattern.len() && pattern[(i - sub_pattern.len())..i] == **sub_pattern {
                possibilities[i] += possibilities[i - sub_pattern.len()]
            }
        }
    }

    *possibilities.last().unwrap()
}
