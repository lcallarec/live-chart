private void register_legend() {
    Test.add_func("/LiveChart/Legend#draw", () => {
        //Given
        var WIDTH = 50;
        var HEIGHT = 50;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context, WIDTH, HEIGHT);

        var legend = new LiveChart.HorizontalLegend();
        var serie = new LiveChart.Serie("TEST",  new LiveChart.Line());;
        legend.add_legend(serie);
         
        //When
        var config = create_config(20, 10);
        legend.draw(context, config);

        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT) ;

        if (pixbuff != null) {
            var pixel_colors = new Gee.HashSet<int>();
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are black or white, background color & serie color
            for(var i = 0 * stride; i < HEIGHT * stride; i=i+pixbuff.bits_per_sample) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                //Legend is white ; but due to color interpolation, pixels can be grey.
                assert(r == g && g == b);
                pixel_colors.add(r);
                assert(alpha == 255);
            }
            //Check if there's not only one (like background) r color generated
            assert(pixel_colors.size > 1);

        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/Legend#draw_hidden", () => {
        //Given
        var WIDTH = 50;
        var HEIGHT = 50;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context, WIDTH, HEIGHT);

        var legend = new LiveChart.HorizontalLegend();
        var serie = new LiveChart.Serie("TEST",  new LiveChart.Line());;
        legend.add_legend(serie);
        legend.visible = false;
         
        //When
        var config = create_config(20, 10);
        legend.draw(context, config);

        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT) ;

        if (pixbuff != null) {
            var pixel_colors = new Gee.HashSet<int>();
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are black or white, background color & serie color
            for(var i = 0 * stride; i < HEIGHT * stride; i=i+pixbuff.bits_per_sample) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0 && g == r && g == b);
                pixel_colors.add(r);
                assert(alpha == 255);
            }


        } else {
            assert_not_reached();
        }
    });      
}