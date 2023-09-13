# svd2zig-core
the core of svd2zig, start from zig version '0.11.0'

## method of import

```zig
const generator = @import("path/to/zig-generator.zig");

var r = try std.fs.cwd().openFile(readfile_name, .{ .mode = .read_only });
defer r.close();
var w = try std.fs.cwd().createFile(writefile_name, .{});
defer w.close();

try generator.generate(allocator, &r.reader(), &w.writer());
```
