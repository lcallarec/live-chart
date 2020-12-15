
private void register_series() {

    Test.add_func("/LiveChart/Series/get", () => {
        //given
        var series = new LiveChart.Series(new LiveChart.Chart());
        
        //when
        series.register(new LiveChart.Serie("Test 1"));
        
        //then
        try {
            assert(series[0].name == "Test 1");
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }
        try {
            var serie = series[1];
            assert(serie.name == "not reached");
            assert_not_reached();
        } catch (LiveChart.ChartError e) {
            
        }
    });

    Test.add_func("/LiveChart/Series/get_by_name", () => {
        //given
        var series = new LiveChart.Series(new LiveChart.Chart());
        
        //when
        series.register(new LiveChart.Serie("Test 1"));
        
        //then
        try {
            assert(series.get_by_name("Test 1").name == "Test 1");
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }
        try {
            var serie = series.get_by_name("Doesn't exist");
            assert(serie.name == "not reached");
            assert_not_reached();
        } catch (LiveChart.ChartError e) {
            
        }
    });

    Test.add_func("/LiveChart/Series/register#update_bounds_when_value_is_added_to_serie", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.Series(chart);
        series.register(new LiveChart.Serie("Test 1"));

        //when
        try {
            series[0].add(100.0);
        } catch (LiveChart.ChartError e) {
            message(e.message);
            assert_not_reached();
        }

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    Test.add_func("/LiveChart/Series/register#should_update_bounds_on_registration_when_value_is_added_to_serie_before_registration", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.Series(chart);
        var serie = new LiveChart.Serie("Test 1");

        serie.add(150.0);
        
        //when
        series.register(serie);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 150.0);
    });    
}

[Version (experimental=true)]
private void register_experimental_series() {
    Test.add_func("/LiveChart/TimeSeries/get", () => {
        //given
        var series = new LiveChart.TimeSeries(new LiveChart.Chart());
        
        //when
        series.register(new LiveChart.LineSerie("Test 1"));
        
        //then
        try {
            assert(series[0].name == "Test 1");
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }
        try {
            var serie = series[1];
            assert(serie.name == "not reached");
            assert_not_reached();
        } catch (LiveChart.ChartError e) {
            
        }
    });

    Test.add_func("/LiveChart/TimeSeries/get_by_name", () => {
        //given
        var series = new LiveChart.TimeSeries(new LiveChart.Chart());
        
        //when
        series.register(new LiveChart.LineSerie("Test 1"));
        
        //then
        try {
            assert(series.get_by_name("Test 1").name == "Test 1");
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }
        try {
            var serie = series.get_by_name("Doesn't exist");
            assert(serie.name == "not reached");
            assert_not_reached();
        } catch (LiveChart.ChartError e) {
            
        }
    });

    Test.add_func("/LiveChart/TimeSeries/register#update_bounds_when_value_is_added_to_serie", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.TimeSeries(chart);
        series.register(new LiveChart.LineSerie("Test 1"));

        //when
        try {
            series[0].add(100.0);
        } catch (LiveChart.ChartError e) {
            message(e.message);
            assert_not_reached();
        }

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    Test.add_func("/LiveChart/TimeSeries/register#should_update_bounds_on_registration_when_value_is_added_to_serie_before_registration", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.TimeSeries(chart);
        var serie = new LiveChart.LineSerie("Test 1");

        serie.add(150.0);
        
        //when
        series.register(serie);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 150.0);
    });   
}