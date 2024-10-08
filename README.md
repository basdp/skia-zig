# Skia Zig Bindings

This repository provides Zig bindings to the Skia C API. It builds Skia for multiple platforms and exposes the raw C headers to be used directly in Zig projects. **No wrappers** are provided—this is a low-level binding to the C layer only.

## Features

- Builds Skia for multiple platforms (Linux, macOS, Windows, etc.)
- Exposes the raw Skia C API headers
- Compatible with Zig's `@cImport` for easy integration

## Getting Started

### Prerequisites

Before building, ensure you have the following dependencies installed:

- Zig (v0.10.0 or higher)
- CMake
- Ninja
- Python 3
- Clang (for compiling Skia)

### Building

To build Skia and set up the bindings for use in Zig, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/skia-zig-bindings.git
    cd skia-zig-bindings
    ```

2. Build Skia for your platform:

    ```bash
    ./build_skia.sh
    ```

    This will download Skia, build it for your platform, and place the compiled libraries and headers in the `build/` directory.

3. Link the Skia libraries and include the C headers in your Zig project.

### Usage

After building, you can import the Skia C API headers in your Zig code as follows:

```zig
const skia = @cImport({
    @cInclude("skia/c/sk_canvas.h");
    @cInclude("skia/c/sk_paint.h");
    @cInclude("skia/c/sk_surface.h");
    // Add other Skia headers as needed
});