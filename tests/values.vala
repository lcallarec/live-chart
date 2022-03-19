
private void register_values() {

    Test.add_func("/LiveChart/Values#Buffer", () => {
        //given
        var values = new LiveChart.Values(2);

        //when 
        values.add({0, 1});
        values.add({2, 100});
        values.add({1, 10});
        
        //then
        assert(values.size == 2);
        //assert(values.get(0) == LiveChart.TimestampedValue(){timestamp = 1, value = 10});
        //assert(values.get(1) == LiveChart.TimestampedValue(){timestamp = 2, value = 100});
		assert(values.first() == LiveChart.TimestampedValue(){timestamp = 1, value = 10});
		assert(values.last() == LiveChart.TimestampedValue(){timestamp = 2, value = 100});
    });
}