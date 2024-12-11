const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var file = try std.fs.cwd().openFile("AoC-Day1.txt", .{});

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var stringRow1 = try std.ArrayList([]const u8).initCapacity(allocator, 1000);
    var stringRow2 = try std.ArrayList([]const u8).initCapacity(allocator, 1000);
    defer stringRow1.deinit();
    defer stringRow2.deinit();
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var split = std.mem.split(u8, line, "   ");
        if (split.next()) |num1| {
            // Allocating memory for each number to ensure unique references
            const copy1 = try allocator.alloc(u8, num1.len);
            @memcpy(copy1, num1);
            try stringRow1.append(copy1);
        }

        if (split.next()) |num2| {
            const copy2 = try allocator.alloc(u8, num2.len);
            @memcpy(copy2, num2);
            try stringRow2.append(copy2);
        }
    }

    file.close();
    try partOne(stringRow1, stringRow2, allocator);
    try partTwo(stringRow1, stringRow2, allocator);
}

pub fn partOne(stringRow1: std.ArrayList([]const u8), stringRow2: std.ArrayList([]const u8), allocator: std.mem.Allocator) !void {
    const stringRow1Len = stringRow1.items.len;
    const stringRow2Len = stringRow2.items.len;
    var row1 = try std.ArrayList(i32).initCapacity(allocator, stringRow1Len);
    var row2 = try std.ArrayList(i32).initCapacity(allocator, stringRow2Len);

    for (stringRow1.items) |item| {
        const number = try std.fmt.parseInt(i32, item, 10);
        try row1.append(number);
    }

    for (stringRow2.items) |item| {
        const number = try std.fmt.parseInt(i32, item, 10);
        try row2.append(number);
    }

    std.mem.sort(i32, row1.items, {}, comptime std.sort.desc(i32));
    std.mem.sort(i32, row2.items, {}, comptime std.sort.desc(i32));

    var differences = try std.ArrayList(i32).initCapacity(allocator, row1.items.len);
    defer differences.deinit();
    for (0..row1.items.len) |index| {
        const num1 = row1.items[index];
        const num2 = row2.items[index];
        var difference: i32 = num1 - num2;
        if (difference < 0)
            difference = difference * -1;
        try differences.append(difference);
    }
    var summericedDifference: i32 = 0;
    for (try differences.toOwnedSlice()) |difference| {
        summericedDifference += difference;
    }

    std.log.info("{d}", .{summericedDifference});
}

pub fn partTwo(stringRow1: std.ArrayList([]const u8), stringRow2: std.ArrayList([]const u8), allocator: std.mem.Allocator) !void {
    const stringRow1Len = stringRow1.items.len;
    const stringRow2Len = stringRow2.items.len;
    var row1 = try std.ArrayList(i32).initCapacity(allocator, stringRow1Len);
    var row2 = try std.ArrayList(i32).initCapacity(allocator, stringRow2Len);
    defer row1.deinit();
    defer row2.deinit();
    for (stringRow1.items) |item| {
        const number = try std.fmt.parseInt(i32, item, 10);
        try row1.append(number);
    }

    for (stringRow2.items) |item| {
        const number = try std.fmt.parseInt(i32, item, 10);
        try row2.append(number);
    }

    const groupCounter = struct { key: i32, counter: i32 = 0 };

    var counterArray = try std.ArrayList(groupCounter).initCapacity(allocator, 25);
    defer counterArray.deinit();
    for (row2.items) |item| {
        var counterGroup: ?*groupCounter = null;
        for (counterArray.items) |*value| {
            if (value.key == item) {
                counterGroup = value;
                break;
            }
        }
        if (counterGroup == null) {
            const newcounterGroup = groupCounter{ .key = item };
            try counterArray.append(newcounterGroup);
            counterGroup = &counterArray.items[counterArray.items.len - 1];
        }
        counterGroup.?.counter += 1;
    }
    var result: i32 = 0;
    for (row1.items) |item| {
        var counterGroup: ?groupCounter = null;
        for (counterArray.items) |value| {
            if (value.key == item) {
                counterGroup = value;
                break;
            }
        }
        result += item * (counterGroup orelse groupCounter{ .key = item, .counter = 0}).counter;
    }

    std.log.info("{d}", .{result});
}
