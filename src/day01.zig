const std = @import("std");
const List = std.ArrayList;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    var items = List(u64).init(gpa);

    var lines = split(u8, data, "\n\n");
    while (lines.next()) |line| {
        var part = split(u8, line, "\n");
        var i: u64 = 0;

        while (part.next()) |thing| {
            if (thing.len == 0) continue;

            i += try parseInt(u64, thing, 10);
        }

        items.append(i) catch unreachable;
    }

    sort(u64, items.items, {}, desc(u64));

    const max_cal1 = items.items[0];
    const max_cal2 = items.items[1];
    const max_cal3 = items.items[2];

    print("Part 1 {d}\n", .{max_cal1});
    print("Part 2 {d}\n", .{max_cal1 + max_cal2 + max_cal3});
}

// Useful stdlib functions
const split = std.mem.split;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const sort = std.sort.sort;
const desc = std.sort.desc;
