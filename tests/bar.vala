private void register_bar() {
    Test.add_func("/LiveChart/Bar#draw", () => {
        //Given
        var WIDTH = 10;
        var HEIGHT = 10;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        context.set_antialias(Cairo.Antialias.NONE);

        var red = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        var white = Gdk.RGBA() {red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0 };

        cairo_background(context, red, WIDTH, HEIGHT);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 180, value: (HEIGHT/2) + 0.5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 1000, value: (HEIGHT/2) + 0.5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 10050, value: (HEIGHT/2) + 0.5});

        var bar = new LiveChart.Bar(values);
        bar.main_color = white;

        //When
        var config = create_config(WIDTH, HEIGHT);
        config.x_axis.tick_length = 1;
        config.x_axis.tick_interval = 1;
        config.padding = LiveChart.Padding() {smart = LiveChart.AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};
        bar.draw(context, config);
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
            pixbuff.savev("/home/laurent/Documents/test.png", "png", {}, {});

        var from_coords = color_at(pixbuff, WIDTH, HEIGHT);

        //Then
        assert(from_coords(0, 0) == red);
        assert(from_coords(0, 1) == red);
        assert(from_coords(0, 2) == red);
        assert(from_coords(0, 3) == red);
        assert(from_coords(0, 4) == white);
        assert(from_coords(0, 5) == white);
        assert(from_coords(0, 6) == white);
        assert(from_coords(0, 7) == white);
        assert(from_coords(0, 8) == white);
        assert(from_coords(0, 9) == white);
    });

    Test.add_func("/LiveChart/Bar#draw#ShouldntRenderIfNoValues", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var values = new LiveChart.Values();
       
        var bar = new LiveChart.Bar(values);
        bar.main_color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        bar.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are black, nothing has been rendered
            for(var i = 0; i < SURFACE_HEIGHT * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });
}
