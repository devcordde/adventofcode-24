pub fn main() {
    let input = include_str!("day09.txt");

    let mut disk_map = vec![];

    for (i, char) in input.chars().enumerate() {
        let length = char.to_digit(10).unwrap();
        let fill = if i % 2 == 0 { Some(i / 2) } else { None };
        for _ in 0..length {
            disk_map.push(fill);
        }
    }

    let mut clean_disk_map = disk_map.clone();

    let free_space = disk_map
        .iter()
        .enumerate()
        .filter(|(_, x)| x.is_none())
        .map(|(i, _)| i)
        .collect::<Vec<_>>();

    let mut part1_free = free_space.iter().rev().collect::<Vec<_>>();
    for (i, block) in disk_map.iter().enumerate().rev() {
        if block.is_none() {
            continue;
        }

        let free = part1_free.pop();

        let free = if let Some(free_index) = free {
            if free_index < &i {
                free_index
            } else {
                break;
            }
        } else {
            break;
        };

        clean_disk_map[*free] = *block;
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

    let mut free_spaces = consecutive_slices(&free_space);

    for (file_id, indices) in index_map.iter().enumerate().rev() {
        let free_space = if let Some(free_space) = free_spaces
            .iter()
            .enumerate()
            .find(|(_, x)| x.len() >= indices.len())
        {
            free_space
        } else {
            continue;
        };

        if free_space.1[0] > indices[0] {
            continue;
        }

        for (i, _) in free_space.1.iter().zip(indices.iter()) {
            clean_disk_map[*i] = Some(file_id);
        }

        let free_space_i = free_space.0;
        let free_space_entry = free_spaces.get_mut(free_space_i).unwrap();

        for (i, _) in indices.iter().enumerate() {
            clean_disk_map[indices[i]] = None;
            free_space_entry.remove(0);
        }
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

fn consecutive_slices(data: &[usize]) -> Vec<Vec<usize>> {
    let mut slice_start = 0;
    let mut result = Vec::new();
    for i in 1..data.len() {
        if data[i - 1] + 1 != data[i] {
            result.push(data[slice_start..i].to_vec());
            slice_start = i;
        }
    }
    if !data.is_empty() {
        result.push(data[slice_start..].to_vec());
    }
    result
}
