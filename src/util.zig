const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const AutoMap = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

// Add utility functions here

pub fn Map(comptime K: type, comptime V: type) type {
    if (K == []const u8) {
        return StrMap(V);
    } else {
        return AutoMap(K, V);
    }
}

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Edge = struct {
            source: T,
            destination: T,
            weight: i32,
        };

        nodes: std.ArrayListUnmanaged(T) = .{},
        edges: std.ArrayListUnmanaged(Edge) = .{},

        pub fn addNode(self: *Self, value: T) !void {
            try self.nodes.append(gpa, value);
        }

        pub fn addEdge(self: *Self, source: T, destination: T, weight: i32) !void {
            try self.edges.append(gpa, Edge{
                .source = source,
                .destination = destination,
                .weight = weight,
            });
        }

        pub fn getChildren(self: *Self, value: T) ![]Edge {
            var list = std.ArrayListUnmanaged(Edge){};

            for (self.edges.items) |edge| {
                if (edge.source == value) {
                    try list.append(gpa, edge);
                }
            }

            return try list.toOwnedSlice(gpa);
        }

        pub fn getParents(self: *Self, value: T) ![]Edge {
            var list = std.ArrayListUnmanaged(Edge){};

            for (self.edges.items) |edge| {
                if (edge.destination == value) {
                    try list.append(gpa, edge);
                }
            }

            return try list.toOwnedSlice(gpa);
        }
    };
}

pub const GridArray = struct {
    width: u64,
    height: u64,

    data: []u8,

    pub fn init(width: u64, height: u64) !GridArray {
        return GridArray{
            .width = width,
            .height = height,
            .data = try gpa.alloc(u8, width * height),
        };
    }

    pub fn deinit(self: *GridArray) void {
        gpa.free(self.data);
    }

    pub fn getPosition(self: GridArray, idx: usize) [2]usize {
        return [_]usize{ idx % self.width, idx / self.width };
    }

    pub fn get(self: *GridArray, x: u64, y: u64) *u8 {
        return &self.data[y * self.width + x];
    }

    pub fn set(self: *GridArray, x: u64, y: u64, value: u8) void {
        self.data[y * self.width + x] = value;
    }

    pub fn clear(self: *GridArray) void {
        std.mem.set(u8, self.data, 0);
    }

    pub fn print(self: *GridArray) void {
        for (self.data) |value| {
            std.debug.print("{c}", .{if (value == 0) ' ' else '#'});
        }
        std.debug.print("", .{});
    }
};

pub const Vector = struct {
    x: f64,
    y: f64,

    pub fn add(self: Vector, other: Vector) Vector {
        return Vector{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn sub(self: Vector, other: Vector) Vector {
        return Vector{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn mul(self: Vector, other: Vector) Vector {
        return Vector{ .x = self.x * other.x, .y = self.y * other.y };
    }

    pub fn div(self: Vector, other: Vector) Vector {
        return Vector{ .x = self.x / other.x, .y = self.y / other.y };
    }

    pub fn scale(self: Vector, scalar: f64) Vector {
        return Vector{ .x = self.x * scalar, .y = self.y * scalar };
    }

    pub fn dot(self: Vector, other: Vector) f64 {
        return self.x * other.x + self.y * other.y;
    }

    pub fn length(self: Vector) f64 {
        return std.math.sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn normalize(self: Vector) Vector {
        return self.scale(1.0 / self.length());
    }

    pub fn angle(self: Vector) f64 {
        return std.math.atan2(self.y, self.x);
    }

    pub fn rotate(self: Vector, angle_rot: f64) Vector {
        const c = std.math.cos(angle_rot);
        const s = std.math.sin(angle_rot);
        return Vector{ .x = self.x * c - self.y * s, .y = self.x * s + self.y * c };
    }

    pub fn angle_between(self: Vector, other: Vector) f64 {
        return std.math.atan2(self.x * other.y - self.y * other.x, self.dot(other));
    }
};

pub fn countOne(data: []const u8, delim: []const u8) usize {
    var pos: usize = 0;
    var n: usize = 0;

    while (std.mem.indexOfPos(u8, data, pos, delim)) |next| {
        pos = next + 1;
        n += 1;
    }

    return n;
}

pub fn countAny(data: []const u8, delims: []const u8) usize {
    var pos: usize = 0;
    var n: usize = 0;

    while (std.mem.indexOfAnyPos(u8, data, pos, delims)) |next| {
        pos = next + 1;
        n += 1;
    }

    return n;
}

pub fn splitOne(data: []const u8, delim: []const u8) ![][]const u8 {
    var ret = try gpa.alloc([]const u8, countOne(data, delim) + 1);
    var it = std.mem.split(u8, data, delim);

    for (ret) |_, i| {
        ret[i] = it.next() orelse unreachable;
    }

    return ret;
}

pub fn splitAny(data: []const u8, delims: []const u8) ![][]const u8 {
    var ret = try gpa.alloc([]const u8, countAny(data, delims) + 1);
    var it = std.mem.tokenize(u8, data, delims);

    // The countAny implementation doesn't ignore sequences of delimitors, while tokenize does, so this will fill as much as possible
    var i: usize = 0;
    while (it.next()) |v| {
        ret[i] = v;
        i += 1;
    }

    return ret;
}

pub fn countCombinations(comptime T: type, comptime range: usize, slice: []const T) usize {
    var n: usize = slice.len;
    var d: usize = range;

    comptime var i = 1;
    inline while (i < range) : (i += 1) {
        n *= slice.len - i;
        d *= i;
    }

    return n / d;
}

pub fn combinations(comptime T: type, comptime range: usize, slice: []const T) ![][range]T {
    const len = countCombinations(T, range, slice);

    var ret = try gpa.alloc([range]T, len);

    var indices: [range]usize = undefined;
    for (indices) |*c, i| {
        c.* = i;
    }

    ret[0] = slice[0..range].*;
    for (ret[1..]) |_, n| {
        var i: usize = range - 1;
        blk: {
            while (i > 0) : (i -= 1) if (i + n >= range and indices[i] != i + n - range) break :blk;
            return ret;
        }

        indices[i] += 1;

        i += 1;
        while (i < range) : (i += 1) {
            indices[i] = indices[i - 1] + 1;
        }

        var next: [range]T = undefined;
        for (indices) |j, x| {
            next[x] = slice[j];
        }

        ret[n] = next;
    }

    unreachable;
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
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
