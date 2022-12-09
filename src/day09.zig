const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day09.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i64 = 0;

    var posmap1 = StrMap(bool).init(gpa);
    var posmap2 = StrMap(bool).init(gpa);

    var knots = [_][2]i32{.{ 0, 0 }} ** 9;

    var x: i32 = 0;
    var y: i32 = 0;

    const pnam1 = std.fmt.allocPrint(gpa, "{d},{d}", .{ x, y }) catch unreachable;
    try posmap1.put(pnam1, true);
    try posmap2.put(pnam1, true);

    var lines = tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        const parts = try util.splitOne(line, " ");

        const c = parts[0][0];
        const n = try parseInt(u8, parts[1], 10);

        var i: usize = 0;
        while (i < n) : (i += 1) {
            switch (c) {
                'U' => y += 1,
                'D' => y -= 1,
                'L' => x -= 1,
                'R' => x += 1,
                else => unreachable,
            }

            for (knots) |*k, j| {
                const nx = if (j == 0) x else knots[j - 1][0];
                const ny = if (j == 0) y else knots[j - 1][1];

                while (max(try std.math.absInt(k[0] - nx), try std.math.absInt(k[1] - ny)) > 1) {
                    if (k[0] - nx > 0) {
                        k[0] -= 1;
                    } else if (k[0] - nx < 0) {
                        k[0] += 1;
                    }

                    if (k[1] - ny > 0) {
                        k[1] -= 1;
                    } else if (k[1] - ny < 0) {
                        k[1] += 1;
                    }

                    if (j == knots.len - 1) {
                        const pnam = try std.fmt.allocPrint(gpa, "{d},{d}", .{ k[0], k[1] });
                        try posmap2.put(pnam, true);
                    } else if (j == 0) {
                        const pnam = try std.fmt.allocPrint(gpa, "{d},{d}", .{ k[0], k[1] });
                        try posmap1.put(pnam, true);
                    }
                }
            }
        }
    }

    var iter1 = posmap1.iterator();
    while (iter1.next()) |_| {
        part1 += 1;
    }

    var iter2 = posmap2.iterator();
    while (iter2.next()) |_| {
        part2 += 1;
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const max = std.math.max;
const print = std.debug.print;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
