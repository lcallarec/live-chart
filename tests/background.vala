private void register_background() {
    Test.add_func("/LiveChart/Background#draw", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var back = new LiveChart.Background();
        back.main_color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        back.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are red, nothing has been rendered
            for(var i = 0 * stride; i < SURFACE_HEIGHT * stride; i=i+pixbuff.bits_per_sample) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

 Test.add_func("/LiveChart/Background#draw_hidden", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var back = new LiveChart.Background();
        back.main_color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        back.visible = false;

        //When
        back.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are red, nothing has been rendered
            for(var i = 0 * stride; i < SURFACE_HEIGHT * stride; i=i+pixbuff.bits_per_sample) {
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