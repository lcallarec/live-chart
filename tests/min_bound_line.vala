private void register_min_bound_line() {
    Test.add_func("/LiveChart/MinBoundLine#AllSeries", () => {
        //Given
        var context = create_context();

        var chart = new LiveChart.Chart();
        chart.config = create_config(context);

        chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
        chart.series.register(new LiveChart.Serie("MIN", new LiveChart.MinBoundLine())).line.color = Gdk.RGBA() {red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 1.0f };;
        
        //When
        try {
            chart.series.get_by_name("S1").add_with_timestamp(8, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);
            chart.series.get_by_name("S2").add_with_timestamp(3, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(10, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context.ctx, chart.config);
            chart.series.get_by_name("S2").draw(context.ctx, chart.config);
            chart.series.get_by_name("MIN").draw(context.ctx, chart.config);
            screenshot(context);

        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First 7th pixels row
            for(var i = 7 * stride; i <= (8 * stride - pixbuff.bits_per_sample * 4); i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                //TODO : AntiAliasing Off
                //  assert(r == 0);
                //  assert(g == 0);
                //  assert(b == 255);
                //  assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/MinBoundLine#OneSerie", () => {
        //Given
        var context = create_context();
        var chart = new LiveChart.Chart();
        chart.config = create_config(context);

        try {
            chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
            chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            chart.series.register(new LiveChart.Serie("MIN OF S2", new LiveChart.MinBoundLine.from_serie(chart.series.get_by_name("S2")))).line.color = Gdk.RGBA() {red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 1.0f };;
            
            //When
     
            chart.series.get_by_name("S1").add_with_timestamp(10, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S2").add_with_timestamp(2, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(6, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context.ctx, chart.config);
            chart.series.get_by_name("S2").draw(context.ctx, chart.config);
            chart.series.get_by_name("MIN OF S2").draw(context.ctx, chart.config);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;

            //First pixels row : the MIN bound line without first 2 pixels (overlaps with S2)
            for(var i = 5 * stride; i < (6 * stride - pixbuff.bits_per_sample * 4 * 2); i=i+pixbuff.bits_per_sample ) {
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