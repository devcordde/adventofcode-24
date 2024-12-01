const std = @import("std");

pub fn main() !void {
    const input = @embedFile("./day01.txt");

    var lines = comptime std.mem.splitSequence(u8, input, "\n");

    // i coulnt figure out how big the buffer should be (apparently this is not big enough)
    // var buffer: [1000 * 4 * 2]u8 = undefined;
    // var fba = std.heap.FixedBufferAllocator.init(&buffer);
    // const allocator = fba.allocator();
    const allocator = std.heap.page_allocator;

    var lhs = std.ArrayList(i32).init(allocator);
    var rhs = std.ArrayList(i32).init(allocator);

    defer lhs.deinit();
    defer rhs.deinit();

    while (lines.next()) |line| {
        var split = std.mem.splitSequence(u8, line, "   ");
        const lhs_str = split.next().?;
        const rhs_str = std.mem.trim(u8, split.next().?, " \r\n");

        try lhs.append(try std.fmt.parseInt(i32, lhs_str, 10));
        try rhs.append(try std.fmt.parseInt(i32, rhs_str, 10));
    }

    std.mem.sort(i32, lhs.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, rhs.items, {}, comptime std.sort.asc(i32));

    var sum: i32 = 0;
    for (lhs.items, rhs.items) |l, r| {
        sum += @as(i32, @intCast(@abs(l - r)));
    }

    std.log.info("Part 1: {d}", .{sum});

    sum = 0;
    for (lhs.items) |l| {
        var found: i32 = 0;
        const index = std.sort.binarySearch(i32, l, rhs.items, .{}, orderI32);
        if (index != null) {
            found = 1;
            const left_side = rhs.items[0..index.?];
            const right_side = rhs.items[index.? + 1 ..];
            var i: usize = left_side.len - 1;
            while (i < left_side.len) : (i -%= 1) {
                const lt = left_side[i];
                if (l == lt) {
                    found += 1;
                } else {
                    break;
                }
            }
            for (right_side) |r| {
                if (l == r) {
                    found += 1;
                } else {
                    break;
                }
            }
        }
        sum += l * found;
    }

    std.log.info("Part 2: {d}", .{sum});
}

fn orderI32(_: @TypeOf(.{}), key: i32, item: i32) std.math.Order {
    return std.math.order(key, item);
}
