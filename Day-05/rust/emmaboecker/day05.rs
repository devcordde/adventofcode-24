use std::cmp::Ordering;

pub fn main() {
    let input = include_str!("day05.txt");

    let (rules, pages) = input.split_at(input.find("\r\n\r\n").unwrap());

    let rules = rules
        .lines()
        .map(|rule| {
            let (before, after) = rule.split_once("|").unwrap();
            (
                before.trim().parse::<i32>().unwrap(),
                after.trim().parse::<i32>().unwrap(),
            )
        })
        .collect::<Vec<_>>();

    let page_lines = pages.lines().skip(2).map(|line| {
        line.split(",")
            .map(|page| page.parse::<i32>().unwrap())
            .collect::<Vec<_>>()
    });

    let mut part1 = 0;
    let mut part2 = 0;
    for pages in page_lines {
        let mut is_sorted = true;
        'page: for (i, page) in pages.iter().enumerate() {
            for (before, after) in rules
                .iter()
                .filter(|(before, after)| pages.contains(before) && pages.contains(after))
            {
                if after == page && !pages[..i].iter().any(|p| p == before) {
                    is_sorted = false;
                    break 'page;
                }
            }
        }
        if is_sorted {
            part1 += pages[pages.len() / 2];
        } else {
            let mut sorted = pages.clone();
            sorted.sort_by(|a, b| {
                let rule = rules
                    .iter()
                    .find(|(before, after)| a == before && b == after);
                if let Some((before, after)) = rule {
                    if a == before && b == after {
                        Ordering::Less
                    } else {
                        Ordering::Greater
                    }
                } else {
                    Ordering::Equal
                }
            });
            part2 += sorted[sorted.len() / 2];
        }
    }

    println!("Part 1: {:?}", part1);
    println!("Part 2: {:?}", part2);
}
