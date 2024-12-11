const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const caputre_Group_mul = struct { group: []const u8, fistNum: i32, secundNum: i32, start_Index: i32, end_index: i32 };

const caputre_Group_do_dont = struct {group: []const u8, start_Index: i32, end_index:i32};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var file = try std.fs.cwd().openFile("Aoc-Day3.txt", .{});
    defer file.close();

    const stat = try file.stat();
    const buffer = try file.readToEndAlloc(allocator, stat.size);
    defer allocator.free(buffer);

    std.mem.replaceScalar(u8, buffer, '\n', 0);



    var mul_Matches = ArrayList(caputre_Group_mul).init(allocator);
    defer mul_Matches.deinit();

    var do_matches = ArrayList(caputre_Group_do_dont).init(allocator);
    defer do_matches.deinit();

    var dont_matches = ArrayList(caputre_Group_do_dont).init(allocator);
    defer dont_matches.deinit();

    var resultSumPartOne: i32 = 0;

    try getMulMatches(buffer, &mul_Matches, allocator);

    try getDoMatches(buffer, &do_matches, allocator);

    try getDontMatches(buffer, &dont_matches, allocator);

    for (mul_Matches.items) |match| {
        resultSumPartOne += (match.fistNum * match.secundNum);
    }

    var resultSumPartTwo: i32 = 0;
    const defaultDo = caputre_Group_do_dont {.group = "" , .start_Index = 0, .end_index = 0};
    const defaultDont = caputre_Group_do_dont {.group = "" , .start_Index = -1, .end_index = -1};
    for (mul_Matches.items) |match| {
        var nearestDo = defaultDo;
        var nearestDont = defaultDont;
        for (do_matches.items) |doMatch| {
            if(doMatch.end_index < match.start_Index){
                nearestDo = doMatch;
            } else {
                break;
            }
        }
        for (dont_matches.items) |dontMatch| {
            if(dontMatch.end_index < match.start_Index){
                nearestDont = dontMatch;
            } else {
                break;
            }
        }
        var doMath = false;
        if(nearestDo.start_Index > nearestDont.end_index){
            doMath = true;
        }

        if(doMath){
            resultSumPartTwo += match.fistNum * match.secundNum;
        }
    }

    std.log.info("Part One: {d}", .{resultSumPartOne});
    std.log.info("Part Two: {d}", .{resultSumPartTwo});
}

fn getDoMatches(buffer: []u8, do_Matches: *ArrayList(caputre_Group_do_dont), allocator: Allocator )  !void {
    var currentMatch = try ArrayList(u8).initCapacity(allocator, 4);
    var possibleDoFound = false;
    var possibleStartIndex: i32 = -1;
    var currentMatchCounter: i32 = 0;
    var endIndex: i32 = -1;
    var validDo = false;
    for (buffer, 0..) |char, index| {
        var matchFound = false;

        if(char == 'd' and !possibleDoFound){
            try currentMatch.append(char);
            possibleDoFound = true;
            possibleStartIndex = @intCast(index);
            matchFound = true;
        }

        if(possibleDoFound and char == 'o' and currentMatchCounter == 1){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(possibleDoFound and char == '(' and currentMatchCounter == 2){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(possibleDoFound and char == ')' and currentMatchCounter == 3){
            try currentMatch.append(char);
            matchFound = true;
            validDo = true;
            endIndex = @intCast(index);
        }

        if(!matchFound){
            possibleDoFound = false;
            possibleStartIndex = -1;
            currentMatchCounter = 0;
            endIndex = -1;
            validDo = false;
            currentMatch.clearRetainingCapacity();
        } else {
            currentMatchCounter += 1;
        }

        if(validDo){
            const result = caputre_Group_do_dont {
                .group = currentMatch.items,
                .start_Index = possibleStartIndex,
                .end_index = endIndex
            };
            try do_Matches.append(result);
            possibleDoFound = false;
            possibleStartIndex = -1;
            currentMatchCounter = 0;
            endIndex = -1;
            validDo = false;
            currentMatch.clearRetainingCapacity();
        }
    }
}
fn getDontMatches(buffer: []u8, dont_Matches: *ArrayList(caputre_Group_do_dont), allocator: Allocator )  !void {
    var currentMatch = try ArrayList(u8).initCapacity(allocator, 7);
    var dontFound = false;
    var possibleStartIndex : i32 = -1;
    var endIndex : i32 = -1;
    var currentMatchCounter: i32 = 0;
    var validDont = false;
    for (buffer, 0..) |char, index| {
        var matchFound = false;

        if(char == 'd' and !dontFound){
            try currentMatch.append(char);
            dontFound = true;
            possibleStartIndex = @intCast(index);
            matchFound = true;
        }

        if(char == 'o' and currentMatchCounter == 1){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(char == 'n' and currentMatchCounter == 2){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(char == '\'' and currentMatchCounter == 3){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(char == 't' and currentMatchCounter == 4){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(char == '(' and currentMatchCounter == 5){
            try currentMatch.append(char);
            matchFound = true;
        }

        if(char == ')' and currentMatchCounter == 6){
            try currentMatch.append(char);
            matchFound = true;
            endIndex = @intCast(index);
            validDont = true;
        }

        if(!matchFound){
            dontFound = false;
            possibleStartIndex = -1;
            endIndex = -1;
            currentMatchCounter = 0;
            validDont = false;
        } else {
            currentMatchCounter += 1;
        }

        if(validDont){
            const result = caputre_Group_do_dont{
                .group = currentMatch.items,
                .start_Index = possibleStartIndex,
                .end_index = endIndex
            };
            try dont_Matches.append(result);
            dontFound = false;
            possibleStartIndex = -1;
            endIndex = -1;
            currentMatchCounter = 0;
            validDont = false;
        }
    }
}

fn getMulMatches(buffer: []u8, mul_Matches: *ArrayList(caputre_Group_mul), allocator: Allocator )  !void {
    var possiblemulFound = false;
    var secoundNumerReached = false;
    var endOfMulReached = false;
    var firstSecNum = true;
    var currentMatchCounter: usize = 0;
    var possibleFirstIndex: i32 = -1;
    var indexFirstNum: usize = 0;
    var indexSecondtNum: usize = 0;
    var possibleFirstNum: i32 = 0;
    var possibleSecoundNum: i32 = 0;
    var currentMatch = try ArrayList(u8).initCapacity(allocator, 12);
    for (buffer, 0..) |char, index| {
        var matchFound = false;

        if (char == 'm' and !possiblemulFound) {
            possiblemulFound = true;
            possibleFirstIndex = @intCast(index);
            try currentMatch.append(char);
            matchFound = true;
        }
        if (possiblemulFound and currentMatchCounter == 1 and char == 'u') {
            try currentMatch.append(char);
            matchFound = true;
        }
        if (possiblemulFound and currentMatchCounter == 2 and char == 'l') {
            try currentMatch.append(char);
            matchFound = true;
        }
        if (possiblemulFound and currentMatchCounter == 3 and char == '(') {
            try currentMatch.append(char);
            matchFound = true;
        }
        if (possiblemulFound and currentMatchCounter == 4 and std.ascii.isDigit(char)) {
            try currentMatch.append(char);
            indexFirstNum = currentMatchCounter;
            matchFound = true;
        }
        if (possiblemulFound and !secoundNumerReached and (std.ascii.isDigit(char) or char == ',') and currentMatchCounter > 4 and currentMatchCounter < 8) {
            try currentMatch.append(char);
            if (char == ',') {
                secoundNumerReached = true;
                possibleFirstNum = try std.fmt.parseInt(i32, currentMatch.items[indexFirstNum..currentMatchCounter], 10);
            }
            matchFound = true;
        }

        if (possiblemulFound and secoundNumerReached and firstSecNum and std.ascii.isDigit(char)) {
            try currentMatch.append(char);
            indexSecondtNum = currentMatchCounter;
            firstSecNum = false;
            matchFound = true;
        }

        if (possiblemulFound and secoundNumerReached and !firstSecNum and !matchFound and (std.ascii.isDigit(char) or char == ')') and (currentMatchCounter - indexSecondtNum) < 4 and currentMatchCounter < currentMatch.capacity) {
            try currentMatch.append(char);
            if (char == ')') {
                endOfMulReached = true;
                possibleSecoundNum = try std.fmt.parseInt(i32, currentMatch.items[indexSecondtNum..currentMatchCounter], 10);
            }
            matchFound = true;
        }

        if (!matchFound) {
            possiblemulFound = false;
            secoundNumerReached = false;
            endOfMulReached = false;
            firstSecNum = true;
            currentMatchCounter = 0;
            possibleFirstIndex = -1;
            indexFirstNum = 0;
            indexSecondtNum = 0;
            possibleFirstNum = 0;
            possibleSecoundNum = 0;
            currentMatch.clearRetainingCapacity();
        } else {
            currentMatchCounter += 1;
        }

        if (endOfMulReached) {
            const result = caputre_Group_mul
            {
                .group = currentMatch.items,
                .fistNum = possibleFirstNum,
                .secundNum = possibleSecoundNum,
                .start_Index = possibleFirstIndex,
                .end_index = @intCast(index)
            };
            try mul_Matches.append(result);
            possiblemulFound = false;
            secoundNumerReached = false;
            endOfMulReached = false;
            firstSecNum = true;
            currentMatchCounter = 0;
            possibleFirstIndex = -1;
            indexFirstNum = 0;
            indexSecondtNum = 0;
            possibleFirstNum = 0;
            possibleSecoundNum = 0;
            currentMatch.clearRetainingCapacity();
        }
    }
}