const std = @import("std");
const List = std.ArrayList;
const StrMap = std.StringHashMap;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i64 = 0;

    var dir: []const u8 = "/";

    var dirs = StrMap(i64).init(gpa);
    try dirs.ensureTotalCapacity(1024);

    var used: i64 = 0;

    var lines = tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        if (line[0] == '$') {
            if (line[2] == 'c' and line[3] == 'd') {
                dir = try std.fs.path.resolve(gpa, &.{ dir, line[5..] });
            } else if (line[2] == 'l' and line[3] == 's') {}
        } else {
            var parts = try util.splitOne(line, " ");

            if (std.mem.eql(u8, parts[0], "dir")) continue;

            const size = try parseInt(i64, parts[0], 10);

            used += size;

            var cur_dir: ?[]const u8 = dir;
            while (cur_dir) |dirname| : (cur_dir = std.fs.path.dirname(dirname)) {
                const gop = try dirs.getOrPut(dirname);
                if (gop.found_existing) {
                    gop.value_ptr.* += size;
                } else {
                    gop.value_ptr.* = size;
                }
            }
        }
    }

    var list = List(i64).init(gpa);
    try list.ensureTotalCapacity(1024);

    var it2 = dirs.iterator();
    while (it2.next()) |entry| {
        try list.append(entry.value_ptr.*);

        if (entry.value_ptr.* <= 100000) {
            part1 += entry.value_ptr.*;
        }
    }

    const max_used = 70000000 - 30000000;

    sort(i64, list.items, {}, asc(i64));
    for (list.items) |size| {
        if (used - size <= max_used) {
            part2 = size;
            break;
        }
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const sort = std.sort.sort;
const asc = std.sort.asc;
