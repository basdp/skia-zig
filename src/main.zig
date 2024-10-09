const c = @cImport({
    @cInclude("skia/include/c/gr_context.h");
    @cInclude("skia/include/c/sk_canvas.h");
    @cInclude("skia/include/c/sk_colorspace.h");
    @cInclude("skia/include/c/sk_data.h");
    @cInclude("skia/include/c/sk_image.h");
    @cInclude("skia/include/c/sk_paint.h");
    @cInclude("skia/include/c/sk_path.h");
    @cInclude("skia/include/c/sk_surface.h");
});

pub usingnamespace c;
