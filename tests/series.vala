
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
    
    Test.add_func("/LiveChart/Series/remove_serie#disconnect_serie.value_add", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.Series(chart);
        var serie = new LiveChart.Serie("Test 1");
        series.register(serie);

        
        //when
        serie.add(150.0);
        series.remove_serie(serie);
        serie.add(200.0);
        
        //then
        assert(chart.config.y_axis.get_bounds().upper == 150.0);
        try{
            series.get_by_name("Test 1");
            assert(false);
        }
        catch(LiveChart.ChartError e){}
    });    
    
    Test.add_func("/LiveChart/Series/remove_all", () => {
        //given
        var chart = new LiveChart.Chart();
        var series = new LiveChart.Series(chart);
        var serie_a = new LiveChart.Serie("Test 1");
        var serie_b = new LiveChart.Serie("Test 2");
        series.register(serie_a);
        series.register(serie_b);

        
        //when
        serie_a.add(150.0);
        serie_b.add(200.0);
        
        series.remove_all();
        serie_b.add(200.0);
        serie_b.add(400.0);
        
        //then
        assert(chart.config.y_axis.get_bounds().upper == 200.0);
        try{
            series.get_by_name("Test 1");
            assert(false);
        }
        catch(LiveChart.ChartError e){}
        
        try{
            series.get_by_name("Test 2");
            assert(false);
        }
        catch(LiveChart.ChartError e){}
    });    
    

}