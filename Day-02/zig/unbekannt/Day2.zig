const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var file = try std.fs.cwd().openFile("Aoc-Day2.txt", .{});

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var rows = try std.ArrayList(std.ArrayList(i32)).initCapacity(allocator, 1000);
    defer rows.deinit();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var split = std.mem.split(u8, line, " ");
        var items = try std.ArrayList(i32).initCapacity(allocator, 10);
        while (split.next()) |num| {
            const copy1 = try allocator.alloc(u8, num.len);
            @memcpy(copy1, num);
            const number = try std.fmt.parseInt(i32, copy1, 10);
            try items.append(number);
        }
        try rows.append(items);
    }

    var validsTask1: i32 = 0;
    var validsTask2: i32 = 0;
    for (rows.items) |row| {
        const result = try validateRow(row, false, allocator);
        if (result)
            validsTask1 = validsTask1 + 1;
    }
    for (rows.items) |row| {
        const result = try validateRow(row, true, allocator);
        if (result)
            validsTask2 = validsTask2 + 1;
    }

    std.log.info("partOne: {d}", .{validsTask1});
    std.log.info("partTwo: {d}", .{validsTask2});
}

fn validateRow(row: std.ArrayList(i32), withDampner: bool, allocator: std.mem.Allocator) !bool {
    var valid = try validate(row.items);
    if (!valid and withDampner) {
        for (row.items, 0..) |_, index| {
            const testRow = try createTestRow(row.items, index, allocator);
            valid = try validate(testRow);
            if(valid)
                break;
        }
    }
    return valid;
}

fn createTestRow(items: []const i32, index: usize, allocator: std.mem.Allocator) ![]i32 {
    const len = items.len;
    if (index >= len) return error.IndexOutOfBounds;

    var result = try allocator.alloc(i32, len - 1);

    for (items[0..index], 0..) |item, i| {
        result[i] = item;
    }

    for (items[index + 1 ..], 0..) |item, i| {
        result[index + i] = item;
    }

    return result;
}

fn validate(row: []i32) !bool {
    var initalRun: bool = true;
    var initalSet: bool = false;
    var isDesc: bool = false;
    var previosNumber: i32 = 0;
    var valid: bool = true;

    for (row) |value| {
        if (!valid) {
            break;
        }

        if (!initalSet) {
            previosNumber = value;
            initalSet = true;
            continue;
        }

        if (value > previosNumber) {
            if (initalRun) {
                initalRun = false;
            }

            if (isDesc) {
                valid = false;
            }
        } else {
            if (initalRun) {
                isDesc = true;
                initalRun = false;
            }

            if (!isDesc) {
                valid = false;
            }
        }
        var diff: i32 = value - previosNumber;
        if (diff < 0)
            diff *= -1;

        if (diff < 1 or diff > 3) {
            valid = false;
        }

        previosNumber = value;
    }

    return valid;
}
