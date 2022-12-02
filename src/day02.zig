const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = trim(u8, @embedFile("data/day02.txt"), "\n");

const a_mask1 = 0b11_00_00;
const b_mask1 = 0b00_11_00;
const c_mask1 = 0b00_00_11;
const a_shift1 = 4;
const b_shift1 = 2;
const c_shift1 = 0;

const a_mask2 = 0b11_00_00 << 8;
const b_mask2 = 0b00_11_00 << 8;
const c_mask2 = 0b00_00_11 << 8;
const a_shift2 = 4 + 8;
const b_shift2 = 2 + 8;
const c_shift2 = 0 + 8;

const score1_table = [_]u8{
    0b01_01_01, // Rock + Rock         = Tie
    0b01_10_10, // Rock + Paper        = Win
    0b01_11_00, // Rock + Scissors     = Lose
    0b10_01_00, // Paper + Rock        = Lose
    0b10_10_01, // Paper + Paper       = Tie
    0b10_11_10, // Paper + Scissors    = Win
    0b11_01_10, // Scissors + Rock     = Win
    0b11_10_00, // Scissors + Paper    = Lose
    0b11_11_01, // Scissors + Scissors = Tie
};

const score2_table = [_]u8{
    0b01_01_11, // Rock + Lose     = Scissors
    0b01_10_01, // Rock + Tie      = Rock
    0b01_11_10, // Rock + Win      = Paper
    0b10_01_01, // Paper + Lose    = Rock
    0b10_10_10, // Paper + Tie     = Paper
    0b10_11_11, // Paper + Win     = Scissors
    0b11_01_10, // Scissors + Lose = Paper
    0b11_10_11, // Scissors + Tie  = Scissors
    0b11_11_01, // Scissors + Win  = Rock
};

const score_table = blk: {
    var table = [_]u16{0} ** 9;

    for (score1_table) |score1, i| {
        table[i] |= score1;
    }

    for (score2_table) |score2, i| {
        table[i] |= @as(u16, score2) << 8;
    }

    break :blk table;
};

const lines_table = blk: {
    @setEvalBranchQuota(100000);
    const n = util.countOne(data, "\n") + 1;

    var table = [_]u16{0} ** n;

    var i: usize = 0;
    var lines = split(u8, data, "\n");
    while (lines.next()) |line| : (i += 1) {
        table[i] = line[0] - 'A' + 1;
        table[i] |= @as(u16, line[2] - 'A' + 1) << 8;
    }

    break :blk table;
};

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var score1: i64 = 0;
    var score2: i64 = 0;

    for (lines_table) |line| {
        const a = @truncate(u8, line);
        const b = @truncate(u8, line >> 8);

        score1 += b;
        score2 += (b - 1) * 3;

        inline for (score_table) |bits| {
            const is_a = (bits & a_mask1) >> a_shift1 == a;
            const is_b = (bits & b_mask1) >> b_shift1 == b;

            if (is_a and is_b) {
                score1 += ((bits & c_mask1) >> c_shift1) * 3;
                score2 += ((bits & c_mask2) >> c_shift2);
            }
        }
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{score1});
    print("Part 2 {d}\n", .{score2});
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
