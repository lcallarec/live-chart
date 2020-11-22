const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;

void cairo_background(Cairo.Context context, Gdk.RGBA color = {0.0, 0.0, 0.0, 1.0}, int? width = null, int? height = null) {
    context.set_source_rgba(color.red, color.green, color.blue, color.alpha);
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
        return {(double) r/255, (double) g/255, (double) b/255, (double) alpha/255};
    };
}

delegate Gee.HashSet<int> IntFromToCoodinates(int from_x, int from_y, int to_x, int to_y);

IntFromToCoodinates unique_int_colors_at(Gdk.Pixbuf pixbuff, int width, int height) {
    unowned uint8[] data = pixbuff.get_pixels_with_length();
    var stride = pixbuff.rowstride;
    
    return (from_x, from_y, to_x, to_y) => {
        var colors = new Gee.HashSet<int>();
        for (var x = from_x; x <= to_x; x++) {
            for (var y = from_y; y <= to_y; y++) {
                var pos = (stride * y) + (4 * x);
            
                var r = data[pos];
                var g = data[pos + 1];
                var b = data[pos + 2];
                var alpha = data[pos + 3];
                colors.add(colors_to_int(r, g, b, alpha));
            }
        }
        return colors;
    };
}

delegate Gee.ArrayList<Gdk.RGBA?> ColorFromToCoodinates(int from_x, int from_y, int to_x, int to_y);
ColorFromToCoodinates colors_at(Gdk.Pixbuf pixbuff, int width, int height) {
    unowned uint8[] data = pixbuff.get_pixels_with_length();
    var stride = pixbuff.rowstride;
    
    return (from_x, from_y, to_x, to_y) => {
        var colors = new Gee.ArrayList<Gdk.RGBA?>();
        for (var x = from_x; x <= to_x; x++) {
            for (var y = from_y; y <= to_y; y++) {
                var pos = (stride * y) + (4 * x);
            
                var r = data[pos];
                var g = data[pos + 1];
                var b = data[pos + 2];
                var alpha = data[pos + 3];
                colors.add({red: (double) r/255, green: (double) g/255, blue: (double) b/255, alpha: (double) alpha/255});
            }
        }
        return colors;
    };
}

int colors_to_int(uint8 red, uint8 green, uint8 blue, uint8 alpha) {
    int rgba = red;
    rgba = (rgba << 8) + green;
    rgba = (rgba << 8) + green;
    rgba = (rgba << 8) + alpha;
    return (int) rgba;
}

int color_to_int(Gdk.RGBA color) {
    return colors_to_int((uint8) color.red * 255, (uint8) color.green * 255, (uint8) color.blue * 255, (uint8) color.alpha * 255);
}

private void register_cairo() {

    Test.add_func("/TestTools/color_at", () => {
        //Given
        var WIDTH = 2;
        var HEIGHT = 2;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var red = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0};
        var blue = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0};

        cairo_background(context, red, WIDTH, HEIGHT);

        context.set_antialias(Cairo.Antialias.NONE);

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
        assert(from_coords(0, 0) == red);
        assert(from_coords(0, 1) == blue);
        assert(from_coords(1, 0) == blue);
        assert(from_coords(1, 1) == red);
    });

    Test.add_func("/TestTools/colors_at", () => {
        //Given
        var WIDTH = 2;
        var HEIGHT = 2;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var red = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0};
        var blue = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0};
        var green = Gdk.RGBA() {red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0};
        var yellow = Gdk.RGBA() {red = 1.0, green = 1.0, blue = 0.0, alpha = 1.0};        

        cairo_background(context, red, WIDTH, HEIGHT);

        context.set_antialias(Cairo.Antialias.NONE);

        context.set_line_width(0.5);
        context.set_line_cap(Cairo.LineCap.ROUND);

        context.set_source_rgba(blue.red, blue.green, blue.blue, blue.alpha);
        context.move_to(0.5, 1.5);
        context.line_to(0.5, 1.5);
        context.stroke();

        context.set_source_rgba(green.red, green.green, green.blue, green.alpha);
        context.move_to(1.5, 0.5);
        context.line_to(1.5, 0.5);
        context.stroke();

        context.set_source_rgba(yellow.red, yellow.green, yellow.blue, yellow.alpha);
        context.move_to(1.5, 1.5);
        context.line_to(1.5, 1.5);
        context.stroke();
        
        //When
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        var from_to_coords = colors_at(pixbuff, WIDTH, HEIGHT);
        //Then
        assert(from_to_coords(0, 0, 1, 1).size == 4);
    });
}
