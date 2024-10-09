const c = @cImport({
    @cInclude("include/c/gr_context.h");
    @cInclude("include/c/sk_canvas.h");
    @cInclude("include/c/sk_colorspace.h");
    @cInclude("include/c/sk_data.h");
    @cInclude("include/c/sk_image.h");
    @cInclude("include/c/sk_paint.h");
    @cInclude("include/c/sk_path.h");
    @cInclude("include/c/sk_surface.h");
});

pub usingnamespace c;
