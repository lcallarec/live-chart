private void register_max_bound_line() {
    Test.add_func("/LiveChart/MaxBoundLine#all_series", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var chart = new LiveChart.Chart();
        chart.config = create_config();
        chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };
        chart.series.register(new LiveChart.Serie("MAX", new LiveChart.MaxBoundLine())).line.color = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0 };;
        
        //When
        try {
            chart.series.get_by_name("S1").add_with_timestamp(0, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);
            chart.series.get_by_name("S2").add_with_timestamp(3, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(7, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context, chart.config);
            chart.series.get_by_name("S2").draw(context, chart.config);
            chart.series.get_by_name("MAX").draw(context, chart.config);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First pixels row : the MAX bound line until last pixel (it overlaps with S1)
            for(var i = 0 * stride; i <= (1 * stride - pixbuff.bits_per_sample * 4); i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 128);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/MaxBoundLine#one_serie", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var chart = new LiveChart.Chart();
        chart.config = create_config();

        try {
            chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
            chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };
            chart.series.register(new LiveChart.Serie("MAX OF S2", new LiveChart.MaxBoundLine.from_serie(chart.series.get_by_name("S2")))).line.color = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0 };;
            
            //When
     
            chart.series.get_by_name("S1").add_with_timestamp(10, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S2").add_with_timestamp(2, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(6, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context, chart.config);
            chart.series.get_by_name("S2").draw(context, chart.config);
            chart.series.get_by_name("MAX OF S2").draw(context, chart.config);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First pixels row : the MAX bound line without last 3 pixels (overlaps with S2)
            for(var i = 5 * stride; i < (6 * stride - pixbuff.bits_per_sample * 4 * 3); i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 128);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    //Experimental
    Test.add_func("/LiveChart/MaxBoundLineSerie#all_series", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var chart = new LiveChart.TimeChart();
        chart.config = create_config();
        chart.series.register(new LiveChart.LineSerie("S1")).line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        chart.series.register(new LiveChart.LineSerie("S2")).line.color = Gdk.RGBA() {red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };
        chart.series.register(new LiveChart.MaxBoundLineSerie("MAX")).line.color = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0 };;
        
        //When
        try {
            chart.series.get_by_name("S1").add_with_timestamp(0, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);
            chart.series.get_by_name("S2").add_with_timestamp(3, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(7, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context, chart.config);
            chart.series.get_by_name("S2").draw(context, chart.config);
            chart.series.get_by_name("MAX").draw(context, chart.config);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First pixels row : the MAX bound line until last pixel (it overlaps with S1)
            for(var i = 0 * stride; i <= (1 * stride - pixbuff.bits_per_sample * 4); i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 128);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/MaxBoundLineSerie#one_serie", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var chart = new LiveChart.TimeChart();
        chart.config = create_config();

        try {
            chart.series.register(new LiveChart.LineSerie("S1")).line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
            chart.series.register(new LiveChart.LineSerie("S2")).line.color = Gdk.RGBA() {red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };
            chart.series.register(new LiveChart.MaxBoundLineSerie.from_serie("MAX OF S2", chart.series.get_by_name("S2"))).line.color = Gdk.RGBA() {red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0 };;
            
            //When
     
            chart.series.get_by_name("S1").add_with_timestamp(10, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S2").add_with_timestamp(2, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(6, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context, chart.config);
            chart.series.get_by_name("S2").draw(context, chart.config);
            chart.series.get_by_name("MAX OF S2").draw(context, chart.config);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First pixels row : the MAX bound line without last 3 pixels (overlaps with S2)
            for(var i = 5 * stride; i < (6 * stride - pixbuff.bits_per_sample * 4 * 3); i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 128);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });    
}