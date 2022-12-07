const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i64 = 0;

    var dir: []const u8 = "/";
    var files = StrMap(i64).init(gpa);

    var lines = tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        if (line[0] == '$') {
            if (line[2] == 'c' and line[3] == 'd') {
                dir = try std.fs.path.resolve(gpa, &.{ dir, line[5..] });
            } else if (line[2] == 'l' and line[3] == 's') {}
        } else {
            var parts = try util.splitOne(line, " ");

            if (std.mem.eql(u8, parts[0], "dir")) continue;

            const file = try std.fs.path.join(gpa, &.{ dir, parts[1] });
            try files.put(file, try parseInt(i64, parts[0], 10));
        }
    }

    var dirs = StrMap(i64).init(gpa);

    var used: i64 = 0;

    var it = files.iterator();
    while (it.next()) |entry| {
        used += entry.value_ptr.*;

        var parts = try util.splitOne(entry.key_ptr.*[1..], "/");

        for (parts[0 .. parts.len - 1]) |_, i| {
            const dirname = try std.fs.path.join(gpa, parts[0 .. i + 1]);

            const gop = try dirs.getOrPut(dirname);
            if (gop.found_existing) {
                gop.value_ptr.* += entry.value_ptr.*;
            } else {
                gop.value_ptr.* = entry.value_ptr.*;
            }
        }
    }

    var list = List(i64).init(gpa);

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
