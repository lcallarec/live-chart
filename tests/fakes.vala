const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;
const Gdk.RGBA DEFAULT_BACKGROUND_COLOR = {1.0, 1.0, 1.0, 1.0};
const double EPSILON = 0.00000001f;

class TestContext : Object {
    public Cairo.Context ctx { get; set; }
    public Cairo.ImageSurface surface { get; set; }
}

TestContext create_context(int width = SURFACE_WIDTH, int height = SURFACE_HEIGHT) {
    Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
    Cairo.Context context = new Cairo.Context(surface);
    context.set_antialias(Cairo.Antialias.NONE);
    cairo_background(context, DEFAULT_BACKGROUND_COLOR, width, height);

    var test_context = new TestContext();
    test_context.ctx = context;
    test_context.surface = surface;

    return test_context;
}

void cairo_background(Cairo.Context ctx, Gdk.RGBA color, int width, int height) {
    ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
    ctx.rectangle(-1, -1,width + 1, height + 1);
    ctx.fill();
}

LiveChart.Config create_config(int? width = null, int? height = null) {
    var config = new LiveChart.Config();
    config.width = width != null ? width : SURFACE_WIDTH;
    config.height = height != null ? height : SURFACE_HEIGHT;
    config.padding = { 0, 0, 0, 0};

    return config;
}

delegate Gee.HashSet<ulong> IntFromToCoodinates(int from_x, int from_y, int to_x, int to_y);

delegate bool HasOnlyOneColor(Gdk.RGBA color);

HasOnlyOneColor has_only_one_color(TestContext context) {
    
    int width = context.surface.get_width();
    int height = context.surface.get_height();
    
    return (color) => {
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, width, height);
        assert(pixbuff != null);

        unowned uint8[] pixels = pixbuff.get_pixels();
        var stride = pixbuff.rowstride;

        var colors = new Gee.HashSet<Gdk.RGBA?>();
        for (var x = 0; x < width; x++) {
            for (var y = 0; y < height; y++) {
                var rgba = get_color_at(pixels, stride)(x, y);
                colors.add(rgba);
            }
        }

        return colors.all_match((c) => {
            return c.equal(color);
        });
    };
}


delegate bool HasOnlyOneColorAtRow(Gdk.RGBA color, int row);
HasOnlyOneColorAtRow has_only_one_color_at_row(TestContext context) {
    
    int width = context.surface.get_width();
    int height = context.surface.get_height();
    
    return (color, row) => {
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, width, height);
        assert(pixbuff != null);

        unowned uint8[] pixels = pixbuff.get_pixels();
        var stride = pixbuff.rowstride;

        var colors = new Gee.HashSet<Gdk.RGBA?>();
        for (var x = 0; x < width; x++) {
            var rgba = get_color_at(pixels, stride)(x, row);
            colors.add(rgba);
        }

        return colors.all_match((c) => {
            return c.equal(color);
        });
    };
}

delegate Gdk.RGBA ColorAtCoodinates(int x, int y);
ColorAtCoodinates get_color_at(uint8[] pixels, int stride) {
    return (x, y) => {

        var pos = (stride * y) + (4 * x);
                
        var r = pixels[pos];
        var g = pixels[pos + 1];
        var b = pixels[pos + 2];
        var alpha = pixels[pos + 3];
        return color8_to_rgba(r, g, b, alpha);
    };
}

ColorAtCoodinates color_at(TestContext context) {
    int width = context.surface.get_width();
    int height = context.surface.get_height();

    return (x, y) => {

        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, width, height);
        assert(pixbuff != null);

        unowned uint8[] pixels = pixbuff.get_pixels();
        var stride = pixbuff.rowstride;

        var pos = (stride * y) + (4 * x);
                
        var r = pixels[pos];
        var g = pixels[pos + 1];
        var b = pixels[pos + 2];
        var alpha = pixels[pos + 3];
        return color8_to_rgba(r, g, b, alpha);
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

Gdk.RGBA color8_to_rgba(uint8 red, uint8 green, uint8 blue, uint8 alpha) {
    return { red / 255, green / 255, blue / 255, alpha / 255 };
}

public class PointBuilder {
    private double _x = 0;
    private double _y = 0;
    private double _height = 0;
    private LiveChart.TimestampedValue _data = { 
        timestamp: 0,
        value: 0
    };

    public PointBuilder.from_value(double value) {
        this._data.value = value;
    }
    public PointBuilder x(double x) {
        this._x = x;
        return this;
    }
    public LiveChart.Point build() {
        return {
            x: this._x,
            y: this._y,
            height: this._height,
            data: _data
        };
    }

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
        //var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        //  var from_coords = color_at(pixbuff, WIDTH, HEIGHT);

        //  //Then
        //  assert(from_coords(0, 0) == red);
        //  assert(from_coords(0, 1) == blue);
        //  assert(from_coords(1, 0) == blue);
        //  assert(from_coords(1, 1) == red);
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
        //var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        //var from_to_coords = colors_at(pixbuff, WIDTH, HEIGHT);
        //Then
        //assert(from_to_coords(0, 0, 1, 1).size == 4);
    });
}
