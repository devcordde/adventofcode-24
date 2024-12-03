use regex::{Captures, RegexBuilder};

enum Instruction {
    Mul(i32, i32),
    Do,
    Dont,
}

pub fn main() {
    let input = include_str!("day03.txt");

    let re = RegexBuilder::new(r"mul\((?<x>\d+),(?<y>\d+)\)|do\(\)|don't\(\)")
        .build()
        .unwrap();
    let instructions = re
        .captures_iter(input)
        .map(|x| parse_instruction(x))
        .collect::<Vec<Instruction>>();

    let part1 = do_instructions(&instructions, true);

    println!("Part 1: {}", part1);

    let part2 = do_instructions(&instructions, false);

    println!("Part 2: {}", part2);
}

fn parse_instruction(instruction: Captures) -> Instruction {
    match instruction.get(0).unwrap().as_str() {
        "do()" => Instruction::Do,
        "don't()" => Instruction::Dont,
        _ => {
            let x = instruction.name("x").unwrap();
            let y = instruction.name("y").unwrap();

            Instruction::Mul(
                x.as_str().parse::<i32>().unwrap(),
                y.as_str().parse::<i32>().unwrap(),
            )
        }
    }
}

fn do_instructions(instructions: &[Instruction], ignore_dos: bool) -> i32 {
    let mut active = true;
    let mut sum = 0;
    for instruction in instructions {
        match instruction {
            Instruction::Mul(x, y) => {
                if active {
                    sum += x * y;
                }
            }
            Instruction::Do => {
                if !ignore_dos {
                    active = true
                }
            }
            Instruction::Dont => {
                if !ignore_dos {
                    active = false
                }
            }
        }
    }
    sum
}
