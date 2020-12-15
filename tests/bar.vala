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
        bar.line.color = white;

        //When
        var config = create_config(WIDTH, HEIGHT);
        config.x_axis.tick_length = 1;
        config.x_axis.tick_interval = 1;
        config.padding = LiveChart.Padding() {smart = LiveChart.AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};
        bar.draw(context, config);
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        
        var top_colors = unique_int_colors_at(pixbuff, WIDTH, HEIGHT)(0, 0, 0, 3);
        assert(top_colors.size == 1);
        assert(top_colors.contains(color_to_int(red)));

        var bootom_colors = unique_int_colors_at(pixbuff, WIDTH, HEIGHT)(0, 4, 0, 9);
        assert(bootom_colors.size == 1);
        assert(bootom_colors.contains(color_to_int(white)));
    });

    Test.add_func("/LiveChart/Bar/draw#shouldnt_render_if_no_values", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var black = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 0.0, alpha = 1.0};
        cairo_background(context, black);

        var values = new LiveChart.Values();
       
        var bar = new LiveChart.Bar(values);
        bar.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        bar.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            var colors = unique_int_colors_at(pixbuff, SURFACE_WIDTH, SURFACE_HEIGHT)(0, 0, SURFACE_WIDTH - 1, SURFACE_HEIGHT - 1);
            assert(colors.size == 1);
            assert(colors.contains(color_to_int(black)));
        } else {
            assert_not_reached();
        }
    });
}

[Version (experimental=true)]
private void register_experimental_bar() {
    Test.add_func("/LiveChart/BarSerie#draw", () => {
        //Given
        var WIDTH = 10;
        var HEIGHT = 10;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        context.set_antialias(Cairo.Antialias.NONE);

        var red = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        var white = Gdk.RGBA() {red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0 };

        cairo_background(context, red, WIDTH, HEIGHT);

        var bar = new LiveChart.BarSerie("Test");
        bar.add_with_timestamp((HEIGHT/2) + 0.5, (GLib.get_real_time() / 1000) - 180);
        bar.add_with_timestamp((HEIGHT/2) + 0.5, (GLib.get_real_time() / 1000) - 1000);
        bar.add_with_timestamp((HEIGHT/2) + 0.5, (GLib.get_real_time() / 1000) - 10050);

        bar.line.color = white;

        //When
        var config = create_config(WIDTH, HEIGHT);
        config.x_axis.tick_length = 1;
        config.x_axis.tick_interval = 1;
        config.padding = LiveChart.Padding() {smart = LiveChart.AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};
        bar.draw(context, config);
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);
        
        var top_colors = unique_int_colors_at(pixbuff, WIDTH, HEIGHT)(0, 0, 0, 3);
        assert(top_colors.size == 1);
        assert(top_colors.contains(color_to_int(red)));

        var bootom_colors = unique_int_colors_at(pixbuff, WIDTH, HEIGHT)(0, 4, 0, 9);
        assert(bootom_colors.size == 1);
        assert(bootom_colors.contains(color_to_int(white)));
    });

    Test.add_func("/LiveChart/BarSerie/draw#shouldnt_render_if_no_values", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var black = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 0.0, alpha = 1.0};
        cairo_background(context, black);

        var bar = new LiveChart.BarSerie("Test");
        bar.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        bar.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            var colors = unique_int_colors_at(pixbuff, SURFACE_WIDTH, SURFACE_HEIGHT)(0, 0, SURFACE_WIDTH - 1, SURFACE_HEIGHT - 1);
            assert(colors.size == 1);
            assert(colors.contains(color_to_int(black)));
        } else {
            assert_not_reached();
        }
    });
}
