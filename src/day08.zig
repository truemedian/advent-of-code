const std = @import("std");

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day08.txt");

const size = 99;

fn getDistance(grid: [size][size]u8, x: usize, y: usize, dx: i32, dy: i32) i32 {
    var max: u8 = grid[x][y];

    var new_x = @intCast(usize, x);
    var new_y = @intCast(usize, y);

    var i: i32 = 0;
    while (true) {
        var new_x_signed = @intCast(i32, new_x) + dx;
        var new_y_signed = @intCast(i32, new_y) + dy;

        if (new_x_signed < 0 or new_x_signed >= size or new_y_signed < 0 or new_y_signed >= size) break;

        new_x = @intCast(usize, new_x_signed);
        new_y = @intCast(usize, new_y_signed);

        i += 1;
        if (grid[new_x][new_y] >= max) break;
    }

    return i;
}

fn getScenicView(grid: [size][size]u8, x: usize, y: usize) i32 {
    var n: i32 = getDistance(grid, x, y, 0, -1);
    var s: i32 = getDistance(grid, x, y, 0, 1);
    var e: i32 = getDistance(grid, x, y, 1, 0);
    var w: i32 = getDistance(grid, x, y, -1, 0);

    return n * s * e * w;
}

pub fn main() !void {
    var timer = std.time.Timer.start() catch unreachable;

    var part1: i64 = 0;
    var part2: i32 = 0;

    const grid = @bitCast([size][size]u8, data[0 .. data.len - 1].*);
    var visible = [_][size]bool{[_]bool{false} ** size} ** size;

    var row: usize = 0;
    while (row < size) : (row += 1) {
        visible[row][0] = true;
        visible[row][size - 1] = true;

        var col: usize = 1;
        var max = grid[row][0];
        while (col < size) : (col += 1) {
            if (grid[row][col] > max) {
                visible[row][col] = true;
                max = grid[row][col];
            }
        }

        col = size - 2;
        max = grid[row][size - 1];
        while (col >= 0) : (col -= 1) {
            if (grid[row][col] > max) {
                visible[row][col] = true;
                max = grid[row][col];
            }

            if (col == 0) break;
        }
    }

    var col: usize = 0;
    while (col < size) : (col += 1) {
        visible[0][col] = true;
        visible[size - 1][col] = true;

        row = 1;
        var max = grid[0][col];
        while (row < size) : (row += 1) {
            if (grid[row][col] > max) {
                visible[row][col] = true;
                max = grid[row][col];
            }
        }

        row = size - 2;
        max = grid[size - 1][col];
        while (row >= 0) : (row -= 1) {
            if (grid[row][col] > max) {
                visible[row][col] = true;
                max = grid[row][col];
            }

            if (row == 0) break;
        }
    }

    for (visible) |vis_row| {
        for (vis_row) |vis| {
            if (vis) {
                part1 += 1;
            }
        }
    }

    for (grid) |_r, x| {
        for (_r) |_, y| {
            part2 = std.math.max(part2, getScenicView(grid, x, y));
        }
    }

    const time = timer.read();

    print("Part 1 {d}\n", .{part1});
    print("Part 2 {d}\n", .{part2});
    print("Took {d}ns\n", .{time});
}

// Useful stdlib functions
const print = std.debug.print;
