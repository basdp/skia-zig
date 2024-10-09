<p align="center">
    <h1 align="center">Skia Zig Bindings</h1>
</p>

<p align="center">
[![Build Zig package](https://github.com/basdp/skia-zig/actions/workflows/build.yml/badge.svg)](https://github.com/basdp/skia-zig/actions/workflows/build.yml)
</p>

<p align="center">A humble wrapper for Skia to Zig.</p>

## Overview

This repository provides Zig bindings to the Skia C API. It builds Skia for multiple platforms and exposes the raw C headers to be used directly in Zig projects. **No wrappers** are provided—this is a low-level binding to the C layer only.

This repository is using the [Skia fork from the Mono project](https://github.com/mono/skia), as they actively maintain a C wrapper for Skia (which is C++ only). We need C wrappers to bridge to Zig. 

## Features

- Pre-built Skia binaries
- Exposes the raw Skia C API headers (exposed throug a simple `@cImport` of the Skia headers)

## Project status
*Warning*: This wrapper is in very early stage and not stable for production use. Also not all 
features and plaforms are ready.

[x] Skia build for Windows x86_64
[ ] Skia build for macOS x86_64
[ ] Skia build for macOS Apple Silicon
[ ] Skia build for Linux

## Getting Started

### Usage

1. Import the `skia-zig` package into your project:
```bash
zig fetch --save https://github.com/basdp/skia-zig/releases/download/alpha-v1/skia-zig-alpha-v1.zip
```

2. Add the dependency to your `build.zig` file, somewhere below `b.addExecutable(...)` or whatever you are building:

```zig
const skia_dep = b.dependency("skia-zig", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("skia-zig", skia_dep.module("skia-zig"));
```

3. You can now import `skia-zig` in your Zig code:
```zig
const skia = @import("skia-zig");

pub fn main() !void {
    const gr_glinterface = skia.gr_glinterface_create_native_interface();
    defer skia.gr_glinterface_unref(gr_glinterface);
    const gr_context = skia.gr_direct_context_make_gl(gr_glinterface) orelse return error.SkiaCreateContextFailed;
    defer skia.gr_direct_context_free_gpu_resources(gr_context);

    const gl_info = skia.gr_gl_framebufferinfo_t{
        .fFBOID = 0,
        .fFormat = gl.RGBA8,
    };

    const samples: = ... // get from GL or something
    const stencil_bits = ... // get from GL or something

    const backendRenderTarget = skia.gr_backendrendertarget_new_gl(640, 480, samples, stencil_bits, &gl_info) orelse return error.SkiaCreateRenderTargetFailed;

    const color_type = skia.RGBA_8888_SK_COLORTYPE;
    const colorspace = null;
    const props = null;
    const surface = skia.sk_surface_new_backend_render_target(@ptrCast(gr_context), backendRenderTarget, skia.BOTTOM_LEFT_GR_SURFACE_ORIGIN, color_type, colorspace, props) orelse return error.SkiaCreateSurfaceFailed;
    defer skia.sk_surface_unref(surface);

    const canvas = skia.sk_surface_get_canvas(surface) orelse unreachable;

    while (/* app is running */) {
        skia.sk_canvas_clear(canvas, 0xffffffff);

        const fill = skia.sk_paint_new() orelse return error.SkiaCreatePaintFailed;
        defer skia.sk_paint_delete(fill);
        skia.sk_paint_set_color(fill, 0xff0000ff);
        skia.sk_canvas_draw_paint(canvas, fill);

        // Your Skia drawing here

        skia.sk_canvas_flush(canvas);
    }
}
```


### Setting your ABI to MSVC on Windows

Skia requires a msvc ABI on Windows, so make sure you target that abi. There are two possible 
options to do so:

1. Set the target from the command line while building:

    ```bash
    zig build -Dtarget=x86_64-windows-msvc
    ```

2. Or better yet; replace the `const target = ...` line in your `build.zig` file:

    ```zig
    const target = b.standardTargetOptions(.{ .default_target = .{
        .abi = if (b.graph.host.result.os.tag == .windows) .msvc else null,
    } });
    ```
