const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

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
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfPosLinear = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfLinear = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
