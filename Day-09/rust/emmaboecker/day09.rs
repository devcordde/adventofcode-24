use std::collections::BTreeMap;

pub fn main() {
    let input = include_str!("../../input/day09.txt");

    let mut disk_map = vec![];

    for (i, char) in input.chars().enumerate() {
        let length = char.to_digit(10).unwrap();
        let fill = if i % 2 == 0 { Some(i / 2) } else { None };
        for _ in 0..length {
            disk_map.push(fill);
        }
    }

    let mut clean_disk_map = disk_map.clone();

    let mut last_free = 0;
    for (i, block) in disk_map.iter().enumerate().rev() {
        if block.is_none() {
            continue;
        }

        let free = clean_disk_map
            .iter()
            .enumerate()
            .skip(last_free)
            .find(|(_, x)| x.is_none());

        let free = if let Some((free_index, _)) = free {
            if free_index < i {
                free_index
            } else {
                break;
            }
        } else {
            break;
        };

        last_free = free + 1;

        clean_disk_map[free] = *block;
        clean_disk_map[i] = None;
    }

    let part1: usize = checksum(&clean_disk_map);

    println!("Part 1: {}", part1);

    let mut clean_disk_map = disk_map.clone();

    let mut index_map: Vec<Vec<usize>> = Vec::new();

    for (i, block) in disk_map.iter().enumerate() {
        if block.is_none() {
            continue;
        }

        if let Some(list) = index_map.get_mut(block.unwrap()) {
            list.push(i);
        } else {
            index_map.insert(block.unwrap(), vec![i]);
        }
    }

    let mut skips = BTreeMap::new();
    'index_map: for (file_id, indices) in index_map.iter().enumerate().rev() {
        let mut free_space: Vec<usize> = vec![];
        let can_skip = skips.get(&indices.len()).unwrap_or(&0);
        for window in clean_disk_map
            .iter()
            .enumerate()
            .skip(*can_skip)
            .collect::<Vec<_>>()
            .windows(indices.len())
        {
            skips.insert(indices.len(), window[0].0);
            if window[0].0 > indices[0] {
                continue 'index_map;
            }
            if window.iter().all(|a| a.1.is_none()) {
                free_space.extend(window.iter().map(|w| w.0));
                break;
            }
        }
        for (i, j) in free_space.iter().enumerate() {
            clean_disk_map[*j] = Some(file_id);
            clean_disk_map[indices[i]] = None;
        }
        free_space.clear();
    }

    let part2: usize = checksum(&clean_disk_map);

    println!("Part 2: {}", part2);
}

fn checksum(disk_map: &[Option<usize>]) -> usize {
    disk_map
        .iter()
        .enumerate()
        .filter(|x| x.1.is_some())
        .map(|(i, x)| i * x.unwrap())
        .sum()
}
