const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var score1: i64 = 0;
    var score2: i64 = 0;

    var lines = split(u8, data, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var part = split(u8, line, " ");

        const a = part.next().?[0];
        const b = part.next().?[0];

        score1 += b - 'W';

        if (a == 'A') {
            if (b == 'X') {
                score1 += 3;

                score2 += 0;
                score2 += 3;
            } else if (b == 'Y') {
                score1 += 6;

                score2 += 3;
                score2 += 1;
            } else if (b == 'Z') {
                score1 += 0;

                score2 += 6;
                score2 += 2;
            }
        } else if (a == 'B') {
            if (b == 'X') {
                score1 += 0;

                score2 += 0;
                score2 += 1;
            } else if (b == 'Y') {
                score1 += 3;

                score2 += 3;
                score2 += 2;
            } else if (b == 'Z') {
                score1 += 6;

                score2 += 6;
                score2 += 3;
            }
        } else if (a == 'C') {
            if (b == 'X') {
                score1 += 6;

                score2 += 0;
                score2 += 2;
            } else if (b == 'Y') {
                score1 += 0;

                score2 += 3;
                score2 += 3;
            } else if (b == 'Z') {
                score1 += 3;

                score2 += 6;
                score2 += 1;
            }
        }

        print("{d}\n", .{score2});
    }

    print("Part 1 {d}\n", .{score1});
    print("Part 2 {d}\n", .{score2});
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
