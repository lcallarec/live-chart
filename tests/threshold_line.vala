private void register_threshold_line() {
    Test.add_func("/LiveChart/ThresholdLine", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var line = new LiveChart.ThresholdLine(7.5);
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        line.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //First two pixels row, before the red line
            for(var i = 0 * stride; i < 1 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Threshold on third pixels row
            for(var i = 2 * stride; i < 3 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //The rest
            for(var i = 3 * stride; i < 10 * stride; i=i+pixbuff.bits_per_sample ) {
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

[Version (experimental=true)]
public void register_experimental_threshold_line() {
    Test.add_func("/LiveChart/ThresholdLineSerie", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var line = new LiveChart.ThresholdLineSerie("Threshold", 7.5);
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        line.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //First two pixels row, before the red line
            for(var i = 0 * stride; i < 1 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Threshold on third pixels row
            for(var i = 2 * stride; i < 3 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //The rest
            for(var i = 3 * stride; i < 10 * stride; i=i+pixbuff.bits_per_sample ) {
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