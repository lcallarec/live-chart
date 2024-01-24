private void register_chart() {

    Test.add_func("/Chart/serie/add_value#should_update_bounds_when_adding_a_value", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when //then
        assert_false(chart.config.y_axis.get_bounds().has_upper());

        //when
        serie.add(100.0);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    //Deprecated
    Test.add_func("/Chart/add_value#should_update_bounds_when_adding_a_value", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when //then
        assert_false(chart.config.y_axis.get_bounds().has_upper());

        //when
        chart.add_value(serie, 100.0);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    Test.add_func("/Chart/export", () => {
        //given
        var chart = new LiveChart.Chart();

        var app = new Gtk.Application ("com.github.live-chart", GLib.ApplicationFlags.FLAGS_NONE);
        app.activate.connect (() => {
            var view = new Gtk.ApplicationWindow(app);
            view.set_child(chart);
            view.present();
        });
        
        Timeout.add(1, () => {
            if(chart.is_started()) {
                try {
                    chart.to_png("export.png");
                } catch (Error e) {
                    assert_not_reached();
                } finally {
                    app.quit();
                }

                //then
                File file = File.new_for_path("export.png");
                assert(true == file.query_exists());
            }
            return true;
        });

        app.run();
    });

    Test.add_func("/Chart/export_should_fails_when_not_realized", () => {
        //given
        var chart = new LiveChart.Chart();

        //when //then
        try {
              chart.to_png("export.png");
              assert_not_reached();
        } catch (Error e) {
              assert(e is LiveChart.ChartError.EXPORT_ERROR);
        }
    });

    Test.add_func("/Chart/add_unaware_timestamp_collection", () => {
        //given
        var chart = new LiveChart.Chart();

        var serie = new LiveChart.Serie("TEST");

        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / chart.config.time.conv_us;
        chart.add_unaware_timestamp_collection(serie, unaware_timestamp_collection, timespan_between_value);

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });

    Test.add_func("/Chart/serie/add_value_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when
        try {
            chart.series[0].add(100);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100);
    });

    //Deprecated
    Test.add_func("/Chart/add_value_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when
        try {
            chart.add_value_by_index(0, 100);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100);
    });

    Test.add_func("/Chart/add_unaware_timestamp_collection_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / chart.config.time.conv_us;
        try {
            chart.add_unaware_timestamp_collection_by_index(0, unaware_timestamp_collection, timespan_between_value);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });   

    Test.add_func("/Chart/#ShouldNotCrashWhenRevealingAChartWithoutAnyValueAdded", () => {
        //given
        var chart = new LiveChart.Chart();
        chart.add_serie(new LiveChart.Serie("Test"));
       
        //when
        //then
        Timeout.add(1000, () => {
            //FIXME: Gtk.main_quit();
            return false;
        });
        //FIXME: Gtk.main();
    });

    Test.add_func("/Chart/background#main_color_should_be_accessible_even_if_deprecated", () => {
        //given
        var chart = new LiveChart.Chart();

        //when
        chart.background.main_color = { 1f, 1f, 1f, 1f };
       
        //then
        //ok
        
    });
    
    Test.add_func("/Chart/#destroy_chart_should_remove_all_series", () => {
        //given
        var chart = new LiveChart.Chart();
        chart.add_serie(new LiveChart.Serie("TEST"));

        //when
        chart.destroy();
      
        //then
        assert(chart.series.size() == 0);
    });

    Test.add_func("/Chart/#destroy_chart_should_stop_refresh", () => {
        //given
        var chart = new LiveChart.Chart();
        chart.add_serie(new LiveChart.Serie("TEST"));

        //when
        chart.destroy();
      
        //then
        assert(chart.refresh_rate == 0);
    });
    
}
