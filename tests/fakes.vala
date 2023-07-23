const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;
const Gdk.RGBA DEFAULT_BACKGROUND_COLOR = { 1.0f, 1.0f, 1.0f, 1.0f };
const double EPSILON = 0.00000001f;

class TestContext : Object {
    public Cairo.Context ctx { get; set; }
    public Cairo.ImageSurface surface { get; set; }
}

TestContext create_context(int width = SURFACE_WIDTH, int height = SURFACE_HEIGHT) {
    Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.RGB24, width, height);
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
    config.padding = { 0, 0, 0, 0 };

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
        var channels = pixbuff.get_n_channels();
        var stride = pixbuff.rowstride;

        var colors = new Gee.HashSet<Gdk.RGBA?>();
        for (var x = 0; x < width - 1; x++) {
            for (var y = 0; y < height - 1; y++) {
                var rgba = get_color_at_from_pixels(pixels, stride, channels)(x, y);
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
        var channels = pixbuff.get_n_channels();
        var stride = pixbuff.rowstride;

        var colors = new Gee.HashSet<Gdk.RGBA?>();
        for (var x = 0; x < width; x++) {
            var rgba = get_color_at_from_pixels(pixels, stride, channels)(x, row);
            colors.add(rgba);
        }

        return colors.all_match((c) => {
            return c.equal(color);
        });
    };
}

delegate Gdk.RGBA GetColorAt(LiveChart.Coord coord);
GetColorAt get_color_at(TestContext context) {
    
    int width = context.surface.get_width();
    int height = context.surface.get_height();
    
    return (coord) => {
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, width, height);
        assert(pixbuff != null);

        unowned uint8[] pixels = pixbuff.get_pixels();
        var channels = pixbuff.get_n_channels();
        var stride = pixbuff.rowstride;

        return get_color_at_from_pixels(pixels, stride, channels)((int) coord.x, (int) coord.y);
    };
}

private delegate Gdk.RGBA ColorAtCoodinates(int x, int y);
private ColorAtCoodinates get_color_at_from_pixels(uint8[] pixels, int stride, int channels) {
    return (x, y) => {

        var pos = (stride * y) + (channels * x);
                
        var r = pixels[pos];
        var g = pixels[pos + 1];
        var b = pixels[pos + 2];
        var alpha = pixels[pos + 3];
        var c = color8_to_rgba(r, g, b, alpha);

        return flat(c);
    };
}

//  void screenshot(TestContext context, string filename) {
//      int width = context.surface.get_width();
//      int height = context.surface.get_height();
    
//      var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, width, height);
//      try {
//          pixbuff.save(filename, "png");
//      } catch {

//      }
//  }

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
                colors.add({red: (float) r/255, green: (float) g/255, blue: (float) b/255, alpha: (float) alpha/255});
            }
        }
        return colors;
    };
}

private Gdk.RGBA color8_to_rgba(uint8 red, uint8 green, uint8 blue, uint8 alpha) {
    return flat({ (float) red / 255f, (float) green / 255f, (float) blue / 255.0f, (float) alpha / 255f });
}

private Gdk.RGBA flat(Gdk.RGBA color) {
    return { (float)Math.ceil(color.red * 100) / 100f, (float)Math.ceil(color.green * 100) / 100f, (float)Math.ceil(color.blue * 100) / 100f, 1f};
}

public class PointBuilder {
    private double _x = 0;
    private double _y = 0;
    private double _height = 0;
    private LiveChart.TimestampedValue _data = LiveChart.TimestampedValue() { 
        timestamp = 0,
        value = 0
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