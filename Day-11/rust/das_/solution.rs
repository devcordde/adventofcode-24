use std::fs;

// Just for fun, this approach obviously doesn't work for part 2
fn main() {
    let mut stones: Vec<u128> = fs::read_to_string("input.txt").unwrap()
        .split_whitespace()
        .map(|stone| stone.parse::<u128>().unwrap())
        .collect();

    for _ in 0..25 {
        let mut new_stones = Vec::new();

        for stone in stones {
            let str = stone.to_string();

            if stone == 0 {
                new_stones.push(1);
            } else if str.len() % 2 == 0 {
                let half = str.len() / 2;
                new_stones.push(str[0..half].parse::<u128>().unwrap());
                new_stones.push(str[half..].parse::<u128>().unwrap());
            } else {
                new_stones.push(stone * 2024);
            }
        }

        stones = new_stones;
    }

    println!("Part 1: {}", stones.len());
    println!("Part 2: too slow")
}
