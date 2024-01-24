private void register_max_bound_line() {
    Test.add_func("/MaxBoundLine/of_all_series", () => {
        //Given
        var blue = Gdk.RGBA() {red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 1.0f };
        var context = create_context(50, 11);

        var chart = new LiveChart.Chart();
        chart.config = create_config(context);

        chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
        chart.series.register(new LiveChart.Serie("MAX", new LiveChart.MaxBoundLine())).line.color = blue;
        
        //When
        try {
            chart.series.get_by_name("S1").add_with_timestamp(0, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);
            chart.series.get_by_name("S2").add_with_timestamp(3, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(7, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context.ctx, chart.config);
            chart.series.get_by_name("S2").draw(context.ctx, chart.config);
            chart.series.get_by_name("MAX").draw(context.ctx, chart.config);

            screenshot(context);

        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        assert(has_only_one_color_at_row(context)(blue, 0));
    });

    Test.add_func("/MaxBoundLine/one_serie", () => {
        //Given
        var blue = Gdk.RGBA() {red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 1.0f };

        var context = create_context(50, 11);

        var chart = new LiveChart.Chart();
        chart.config = create_config(context);

        try {
            chart.series.register(new LiveChart.Serie("S1")).line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
            chart.series.register(new LiveChart.Serie("S2")).line.color = Gdk.RGBA() {red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            chart.series.register(new LiveChart.Serie("MAX OF S1", new LiveChart.MaxBoundLine.from_serie(chart.series.get_by_name("S1")))).line.color = blue;
            
            //When
     
            chart.series.get_by_name("S1").add_with_timestamp(10, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S1").add_with_timestamp(10, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S2").add_with_timestamp(2, (GLib.get_real_time() / 1000) - 1500);
            chart.series.get_by_name("S2").add_with_timestamp(6, GLib.get_real_time() / 1000);

            chart.series.get_by_name("S1").draw(context.ctx, chart.config);
            chart.series.get_by_name("S2").draw(context.ctx, chart.config);
            chart.series.get_by_name("MAX OF S1").draw(context.ctx, chart.config);

            screenshot(context);

        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }        
 
        //Then
        assert(has_only_one_color_at_row(context)(blue, 0));

    });
}