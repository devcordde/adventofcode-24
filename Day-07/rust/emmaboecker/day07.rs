pub fn main() {
    let input = include_str!("day07.txt");

    let calibrations = input
        .lines()
        .map(|line| {
            let (calibration_result, calibration_values) = line.split_once(": ").unwrap();

            let calibration_result = calibration_result.trim().parse::<i64>().unwrap();
            let calibration_values = calibration_values
                .split(" ")
                .map(|value| value.trim().parse::<i64>().unwrap())
                .collect::<Vec<_>>();

            (calibration_result, calibration_values)
        })
        .collect::<Vec<_>>();

    let mut part1 = 0;

    for (calibration_result, calibration_values) in calibrations.clone() {
        for combination in (0..=2_usize.pow((calibration_values.len() - 1) as u32)).map(|i| {
            let binary = format_radix(i as u32, 2, calibration_values.len() - 1);
            binary.chars().rev().collect::<String>()
        }) {
            let result = calibration_values.windows(2).zip(combination.chars()).fold(
                calibration_values[0],
                |acc, (values, operation)| match operation {
                    '0' => acc + values[1],
                    '1' => acc * values[1],
                    _ => panic!("Invalid character"),
                },
            );

            if result == calibration_result {
                part1 += calibration_result;
                break;
            }
        }
    }

    println!("Part 1: {:?}", part1);

    let mut part2 = 0;

    let max = calibrations
        .iter()
        .map(|(_, values)| values.len())
        .max()
        .unwrap();
    let combinations = (0..=3_usize.pow(max as u32))
        .map(|i| {
            let ternary = format_radix(i as u32, 3, max);
            ternary.chars().rev().collect::<String>()
        })
        .collect::<Vec<_>>();
    for (calibration_result, calibration_values) in calibrations {
        for combination in combinations.iter() {
            let result = calibration_values.windows(2).zip(combination.chars()).fold(
                calibration_values[0],
                |acc, (values, operation)| match operation {
                    '0' => acc + values[1],
                    '1' => acc * values[1],
                    '2' => acc * i64::from(10).pow(values[1].ilog(10) + 1) + values[1],
                    _ => panic!("Invalid character"),
                },
            );

            if result == calibration_result {
                part2 += calibration_result;
                break;
            }
        }
    }

    println!("Part 2: {:?}", part2);
}

fn format_radix(mut x: u32, radix: u32, min: usize) -> String {
    let mut result = String::new();
    while x > 0 {
        let remainder = x % radix;
        result = remainder.to_string() + &result;
        x /= radix;
    }
    if result.is_empty() {
        "0".to_string()
    } else {
        format!("{:0>width$}", result, width = min)
    }
}
