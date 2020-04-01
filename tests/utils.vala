
private void register_utils() {

    Test.add_func("/LiveChart/Utils/Ceil#IntegerBelow10", () => {
        //given
        var fixed_max = 8.2f;

        //when 
        var next = LiveChart.cap((int) fixed_max);
        //then
        assert(next == 9f);
    });

    Test.add_func("/LiveChart/Utils/Ceil#IntegerBelow100", () => {
        //given
        var fixed_max = 76f;

        //when 
        var next = LiveChart.cap((int) fixed_max);
        
        //then
        assert(next == 80f);
    });

    Test.add_func("/LiveChart/Utils/Ceil#IntegerBelow1000", () => {
        //given
        var fixed_max = 923f;

        //when 
        var next = LiveChart.cap((int) fixed_max);
        
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
}