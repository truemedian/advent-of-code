const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

fn lt(_: void, a: List(u8), b: List(u8)) bool {
    return a.items.len > b.items.len;
}

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var stacks1: [9]List(u8) = undefined;
    var stacks2: [9]List(u8) = undefined;

    for (stacks1) |*s| {
        s.* = List(u8).init(gpa);
    }

    for (stacks2) |*s| {
        s.* = List(u8).init(gpa);
    }

    var chunks = split(u8, data, "\n\n");
    const first = chunks.next() orelse unreachable;

    var lines_stacks = tokenize(u8, first, "\n");
    var j: usize = 0;
    while (lines_stacks.next()) |line| : (j += 1) {
        if (line[1] == '1') break;

        var i: usize = 1;
        var x: usize = 0;
        while (i < line.len) : ({
            i += 4;
            x += 1;
        }) {
            if (line[i] == ' ') continue;
            stacks1[x].insert(0, line[i]) catch unreachable;
            stacks2[x].insert(0, line[i]) catch unreachable;
        }
    }

    const second = chunks.next() orelse unreachable;

    var lines = tokenize(u8, second, "\n");
    while (lines.next()) |line| {
        const parts = try util.splitAny(line, " ");

        const num = try parseInt(u16, parts[1], 10);
        const from = try parseInt(u16, parts[3], 10) - 1;
        const to = try parseInt(u16, parts[5], 10) - 1;

        var pos = stacks2[to].items.len;

        var i: usize = 0;
        while (i < num) : (i += 1) {
            stacks1[to].append(stacks1[from].popOrNull() orelse break) catch unreachable;
            stacks2[to].insert(pos, stacks2[from].popOrNull() orelse break) catch unreachable;
        }
    }

    const time = timer.read();
    print("Took {d}ns\n", .{time});

    print("Part 1 ", .{});
    for (stacks1) |s| {
        if (s.items.len == 0) continue;
        const c = s.items[s.items.len - 1];
        print("{c}", .{c});
    }
    print("\n", .{});

    print("Part 2 ", .{});
    for (stacks2) |s| {
        if (s.items.len == 0) continue;
        const c = s.items[s.items.len - 1];
        print("{c}", .{c});
    }
    print("\n", .{});
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
