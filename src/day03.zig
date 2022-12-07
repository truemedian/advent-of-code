const std = @import("std");
const List = std.ArrayList;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i64 = 0;

    var items = List(i64).init(gpa);
    _ = items;

    const lines = try util.splitOne(data, "\n");

    var sets: [3][]const u8 = .{ "", "", "" };

    for (lines) |line, i| {
        const first_half = line[0 .. line.len / 2];
        const second_half = line[line.len / 2 ..];

        for (first_half) |c| {
            if (indexOf(u8, second_half, c) != null) {
                if (c < 'a') {
                    part1 += c - 'A' + 27;
                } else {
                    part1 += c - 'a' + 1;
                }

                break;
            }
        }

        sets[i % 3] = line;

        if (i % 3 == 2) {
            for (sets[0]) |c| {
                if (indexOf(u8, sets[1], c) != null and indexOf(u8, sets[2], c) != null) {
                    if (c < 'a') {
                        part2 += c - 'A' + 27;
                    } else {
                        part2 += c - 'a' + 1;
                    }

                    break;
                }
            }
        }
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
}

// Useful stdlib functions
const indexOf = std.mem.indexOfScalar;
const print = std.debug.print;
