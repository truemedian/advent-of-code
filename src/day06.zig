const std = @import("std");

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: usize = 0;
    var part2: usize = 0;

    var i: usize = 0;
    outer: while (i < data.len - 14) : (i += 1) {
        var x = [_]bool{false} ** 256;

        for (data[i..][0..4]) |c| {
            if (x[c] == true) continue :outer;
            x[c] = true;
        }

        if (part1 == 0) part1 = i + 4;

        for (data[i..][4..14]) |c| {
            if (x[c] == true) continue :outer;
            x[c] = true;
        }

        part2 = i + 14;

        break;
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
}

// Useful stdlib functions
const print = std.debug.print;
