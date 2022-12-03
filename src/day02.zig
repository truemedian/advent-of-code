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

const ScoreEntry = packed struct(u8) {
    const Pick = enum(u2) {
        rock,
        paper,
        scissors,
    };

    const Outcome = enum(u2) {
        lose,
        tie,
        win,
    };

    a: Pick,
    b: Pick,
    c1: Outcome,
    c2: Pick,
};

const score_table = [_]ScoreEntry{
    .{ .a = .rock, .b = .rock, .c1 = .tie, .c2 = .scissors },
    .{ .a = .rock, .b = .paper, .c1 = .win, .c2 = .rock },
    .{ .a = .rock, .b = .scissors, .c1 = .lose, .c2 = .paper },
    .{ .a = .paper, .b = .rock, .c1 = .lose, .c2 = .rock },
    .{ .a = .paper, .b = .paper, .c1 = .tie, .c2 = .paper },
    .{ .a = .paper, .b = .scissors, .c1 = .win, .c2 = .scissors },
    .{ .a = .scissors, .b = .rock, .c1 = .win, .c2 = .paper },
    .{ .a = .scissors, .b = .paper, .c1 = .lose, .c2 = .scissors },
    .{ .a = .scissors, .b = .scissors, .c1 = .tie, .c2 = .rock },
};

pub const Line = packed struct(u4) {
    a: u2 = 0,
    b: u2 = 0,
};

const lines_table = blk: {
    @setEvalBranchQuota(100000);
    const n = util.countOne(data, "\n") + 1;

    var table = [_]Line{.{}} ** n;

    var i: usize = 0;
    var lines = split(u8, data, "\n");
    while (lines.next()) |line| : (i += 1) {
        table[i].a = @truncate(u2, line[0] - 'A');
        table[i].b = @truncate(u2, line[2] - 'X');
    }

    break :blk table;
};

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var score1: i64 = 0;
    var score2: i64 = 0;

    for (lines_table) |line| {
        score1 += line.b + 1;
        score2 += @as(u4, line.b) * 3;

        inline for (score_table) |bits| {
            if (@enumToInt(bits.a) == line.a and @enumToInt(bits.b) == line.b) {
                score1 += @as(u4, @enumToInt(bits.c1)) * 3;
                score2 += @enumToInt(bits.c2) + 1;
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
