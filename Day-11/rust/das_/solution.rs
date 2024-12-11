use std::fs;

// Just for fun, this approach obviously doesn't work for part 2
fn main() {
    let content = fs::read_to_string("input.txt").unwrap();
    let mut numbers = Vec::new();
    for x in content.split(" ") {
        numbers.push(x.parse::<u128>().unwrap());
    }

    for _ in 0..25 {
        let mut new_numbers = Vec::new();

        for (_, stone) in numbers.iter().enumerate() {
            let str = stone.to_string();

            if *stone == 0 {
                new_numbers.push(1);
            } else if str.len() % 2 == 0 {
                let half = str.len() / 2;
                new_numbers.push(str[0..half].parse::<u128>().unwrap());
                new_numbers.push(str[half..].parse::<u128>().unwrap());
            } else {
                new_numbers.push(stone * 2024);
            }
        }

        numbers = new_numbers;
    }

    println!("Part 1: {}", numbers.len());
    println!("Part 2: too slow")
}
