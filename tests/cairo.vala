const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;

void cairo_background(Cairo.Context context, int? width = null, int? height = null) {
    context.set_source_rgba(0.0, 0.0, 0.0, 1.0);
    context.rectangle(0, 0, width != null ? width : SURFACE_WIDTH, height != null ? height : SURFACE_HEIGHT);
    context.fill();
}

LiveChart.Config create_config(int? width = null, int? height = null) {
    var config = new LiveChart.Config();
    config.width = width != null ? width : SURFACE_WIDTH;
    config.height = height != null ? height : SURFACE_HEIGHT;
    config.padding = { 0, 0, 0, 0};

    return config;
}

delegate Gdk.RGBA FromCoodinates(int x, int y);

FromCoodinates color_at(Gdk.Pixbuf pixbuff, int width, int height) {
    unowned uint8[] data = pixbuff.get_pixels_with_length();
    var stride = pixbuff.rowstride;
    return (x, y) => {
        var pos = (stride * y) + (4 * x);
        var r = data[pos];
        var g = data[pos + 1];
        var b = data[pos + 2];
        var alpha = data[pos + 3];
        return {r/255, g/255, b/255, alpha/255};
    };
}

private void register_cairo() {

    Test.add_func("/TestTools/color_at", () => {
        //Given
        var WIDTH = 2;
        var HEIGHT = 2;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var black = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0};
        var blue = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0};

        cairo_background(context, WIDTH, HEIGHT);

        context.set_antialias (Cairo.Antialias.NONE);

        context.set_line_width(0.5);
        context.set_source_rgba(blue.red, blue.green, blue.blue, blue.alpha);
        context.set_line_cap(Cairo.LineCap.ROUND);

        context.move_to(0.5, 1.5);
        context.line_to(0.5, 1.5);

        context.move_to(1.5, 0.5);
        context.line_to(1.5, 0.5);

        context.stroke();
        
        //When
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        var from_coords = color_at(pixbuff, WIDTH, HEIGHT);

        //Then
        assert(from_coords(0, 0) == black);
        assert(from_coords(0, 1) == blue);
        assert(from_coords(1, 0) == blue);
        assert(from_coords(1, 1) == black);
    });
}
