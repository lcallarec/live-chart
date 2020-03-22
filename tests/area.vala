private void register_line_area() {

    Test.add_func("/LiveChart/LineArea#Draw", () => {
        //Given
        const int SURFACE_WIDTH = 10;
        const int SURFACE_HEIGHT = 10;

        var red = Gdk.RGBA() {
            red = 1.0,
            green = 0.0,
            blue = 0.0,
            alpha = 1.0
        };

        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var values = new LiveChart.Values();
        //Two points to draw an horizontal line
        values.add({timestamp: (GLib.get_real_time() / 1000) - 10000, value: 5.5});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5.5});

        var line = new LiveChart.LineArea(values);
        line.main_color = red;
        line.area_alpha = 0.5;

        var config = new LiveChart.Config();
        config.width = SURFACE_WIDTH;
        config.height = SURFACE_HEIGHT;
        config.padding = { 0, 0, 0, 0};

        //When
        line.draw(context, config);
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //Fourth pixels row, before the red line : 
            for(var i = 3 * stride; i < 4 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Fifth pixels row, the red line :             
            for(var i = 4 * stride; i < 5 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r ==255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Sixth pixels row, the area (50% red)               
            for(var i = 5 * stride; i < 6 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 128);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });
}

void cairo_background(Cairo.Context context) {
    context.set_source_rgba(0.0, 0.0, 0.0, 1.0);
    context.rectangle(0, 0, 10, 10);
    context.fill();
}
