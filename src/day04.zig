const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        const parts = try util.splitOne(line, ",");

        const a1 = try util.splitOne(parts[0], "-");
        const b1 = try util.splitOne(parts[1], "-");

        const a = try parseInt(u32, a1[0], 10);
        const b = try parseInt(u32, a1[1], 10);
        const x = try parseInt(u32, b1[0], 10);
        const y = try parseInt(u32, b1[1], 10);

        if (a >= x and b <= y or a <= x and b >= y) {
            part1 += 1;
        }

        // Is there any overlap
        if (b >= x and a <= y) {
            part2 += 1;
        }
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
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
