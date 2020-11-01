
private void register_series() {

    Test.add_func("/LiveChart/Series/get", () => {
        //given
        var series = new LiveChart.Series();
        
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
        var series = new LiveChart.Series();
        
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
}