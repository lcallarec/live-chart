private void register_threshold_line() {
    Test.add_func("/LiveChart/ThresholdLine", () => {
        //Given
        var context = create_context(SURFACE_WIDTH, SURFACE_HEIGHT);

        var line = new LiveChart.ThresholdLine(7.5);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //First two pixels row, before the red line
            for(var i = 0 * stride; i < 1 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 255);
                assert(g == 255);
                assert(b == 255);
                assert(alpha == 255);
            }

            //Threshold on third pixels row
            for(var i = 2 * stride; i < 3 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                //TODO : AntiAliasing Off
                //assert(r == 255);
                //assert(g == 0);
                //assert(b == 0);
                //assert(alpha == 255);
            }

            //The rest
            for(var i = 3 * stride; i < 10 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 255);
                assert(g == 255);
                assert(b == 255);
                assert(alpha == 255);
            }

        } else {
            assert_not_reached();
        }
    });
}