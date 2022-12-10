const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day10.txt");

const CRT = struct {
    const OperationTag = enum {
        noop,
        addx,
    };

    const Operation = union(OperationTag) {
        noop,
        addx: i64,
    };

    x: i64 = 1,

    cycle: u64 = 1,

    pcc: u8 = 0,
    pc: usize = 0,
    insts: []const Operation,

    screen: util.GridArray,

    pub fn next(self: *CRT) bool {
        if (self.pc >= self.insts.len) return false;

        if (std.math.absCast((@intCast(i64, (self.cycle - 1) % 40) - self.x)) <= 1) {
            self.screen.set((self.cycle - 1) % 40, (self.cycle - 1) / 40, '#');
        } else {
            self.screen.set((self.cycle - 1) % 40, (self.cycle - 1) / 40, '.');
        }

        self.cycle += 1;
        self.pcc += 1;

        const inst = self.insts[self.pc];

        switch (inst) {
            .noop => {
                if (self.pcc == 1) {
                    self.pc += 1;
                    self.pcc = 0;
                    return true;
                }
            },
            .addx => |d| {
                if (self.pcc == 2) {
                    self.x += d;

                    self.pc += 1;
                    self.pcc = 0;
                    return true;
                }
            },
        }

        return true;
    }
};

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var insts = List(CRT.Operation).init(gpa);

    var lines = tokenize(u8, data, "\n");
    while (lines.next()) |line| {
        const parts = try util.splitOne(line, " ");

        const op = std.meta.stringToEnum(CRT.OperationTag, parts[0]) orelse @panic("invalid op");

        const inst = switch (op) {
            .noop => CRT.Operation{ .noop = {} },
            .addx => CRT.Operation{ .addx = try parseInt(i64, parts[1], 10) },
        };

        try insts.append(inst);
    }

    var crt = CRT{
        .insts = insts.items,
        .screen = try util.GridArray.init(40, 6),
    };

    var part1: i64 = 0;

    while (crt.next()) {
        if ((crt.cycle + 20) % 40 == 0) {
            print("{d} {d}\n", .{ crt.cycle, crt.x });
            part1 += @intCast(i64, crt.cycle) * crt.x;
        }
    }
    const time = timer.read();

    print("Part 1 {d}\n", .{part1});

    crt.screen.print();

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
