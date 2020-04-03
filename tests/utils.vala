
private void register_utils() {

    Test.add_func("/LiveChart/Utils/Cap#IntegerBelow10", () => {
        //given
        var fixed_max = 8.2f;

        //when 
        var next = LiveChart.cap(fixed_max);
        //then
        assert(next == 9f);
    });

    Test.add_func("/LiveChart/Utils/Cap#IntegerAlreadyCapped", () => {
        //given
        var fixed_max = 10f;

        //when 
        var next = LiveChart.cap(fixed_max);
        //then
        assert(next == 10f);
    });

    Test.add_func("/LiveChart/Utils/Cap#IntegerBelow100", () => {
        //given
        var fixed_max = 76f;

        //when 
        var next = LiveChart.cap(fixed_max);
        
        //then
        assert(next == 80f);
    });

    Test.add_func("/LiveChart/Utils/Cap#IntegerBelow1000", () => {
        //given
        var fixed_max = 923f;

        //when 
        var next = LiveChart.cap(fixed_max);
        
        //then
        assert(next == 1000f);
    });

    Test.add_func("/LiveChart/Utils/HasFractionalPart#8", () => {
        //given
        var value = 8;

        //when 
        var has_fractional_part = LiveChart.has_fractional_part(value);
        
        //then
        assert(has_fractional_part == false);
    });

    Test.add_func("/LiveChart/Utils/HasFractionalPart#8.00", () => {
        //given
        var value = 8.00f;

        //when 
        var has_fractional_part = LiveChart.has_fractional_part(value);
        
        //then
        assert(has_fractional_part == false);
    });

    Test.add_func("/LiveChart/Utils/HasFractionalPart#8.86", () => {
        //given
        var value = 8.86f;

        //when 
        var has_fractional_part = LiveChart.has_fractional_part(value);
        
        //then
        assert(has_fractional_part == true);
    });

    Test.add_func("/LiveChart/Utils/golden_divisors", () => {
        //given
        var value = 100f;

        //when 
        var divisors = LiveChart.golden_divisors(value);

        //then
        assert(divisors.get(0) == 50);
        assert(divisors.get(1) == 25); // Golden: 50 / 2 = 25
        //assert(divisors.get(2) == 20); Not golden: 25 / 2 != 20
        assert(divisors.get(2) == 10); // Golden: 20 / 2 = 10
        assert(divisors.get(3) == 5); //Golden; 10 / 2 = 5
        //assert(divisors.get(4) == 4); Not golden
        assert(divisors.get(4) == 2); // Golden
        assert(divisors.get(5) == 1); // Golden
    });

    Test.add_func("/LiveChart/Utils/golden_divisors_value_below_1", () => {
        //given
        var value = 0.10f;

        //when 
        var divisors = LiveChart.golden_divisors(value);

        //then
        assert(divisors.get(0) == 50f);
        assert(divisors.get(1) == 25f);
        assert(divisors.get(2) == 10f);
        assert(divisors.get(3) == 5f);
        assert(divisors.get(4) == 2f);
        assert(divisors.get(5) == 1f);
    });    
}