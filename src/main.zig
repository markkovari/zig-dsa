const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn Stack(comptime T: type) type {
    return struct {
        stack: ArrayList(T),
        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return Self{ .stack = ArrayList(T).init(allocator) };
        }

        pub fn deinit(self: *Self) void {
            self.stack.deinit();
        }

        pub fn push(self: *Self, element: T) !void {
            try self.stack.append(element);
        }

        pub fn pop(self: *Self) ?T {
            return self.stack.popOrNull();
        }

        pub fn isEmpty(self: *Self) bool {
            return self.stack.items.len == 0;
        }

        pub fn count(self: *Self) usize {
            return self.stack.items.len;
        }

        pub fn top(self: *Self) ?T {
            if (self.stack.items.len == 0) {
                return null;
            }
            return self.stack.items[self.stack.items.len - 1];
        }
    };
}

test {
    const expect = std.testing.expect;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const IntStack = Stack(i32);

    var stack = IntStack.init(gpa.allocator());
    defer stack.deinit();

    try stack.push(1);
    try stack.push(2);
    try stack.push(3);

    try expect(stack.isEmpty() == false);

    try expect(stack.top().? == 3);
    try expect(stack.pop().? == 3);
    try expect(stack.top().? == 2);
    try expect(stack.pop().? == 2);
    try expect(stack.top().? == 1);
    try expect(stack.pop().? == 1);

    try expect(stack.isEmpty() == true);
}

test {
    const Hay = struct {
        const Self = @This();
        val: i32,
        pub fn init(value: i32) Self {
            return Self{ .val = value };
        }
        pub fn eq(self: *Self, other: *Self) bool {
            return self.val == other.val;
        }
    };
    const expect = std.testing.expect;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const HayStack = Stack(Hay);

    var stack = HayStack.init(gpa.allocator());
    defer stack.deinit();

    try stack.push(.{ .val = 2 });
    try stack.push(.{ .val = 3 });
    try stack.push(.{ .val = 4 });

    try expect(stack.isEmpty() == false);

    var next = stack.pop();
    try expect(next != null);
    try expect(next.?.val == 4);

    next = stack.pop();
    try expect(next != null);
    try expect(next.?.val == 3);

    next = stack.pop();
    try expect(next != null);
    try expect(next.?.val == 2);

    try expect(stack.isEmpty() == true);

    next = stack.pop();
    try expect(next == null);
}
