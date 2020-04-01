using Cairo;

namespace LiveChart { 

    public static int cap(int value) {
        var num_digits = num_of_digits(value);
        var size = Math.exp10((double) num_digits - 1);

        double integer_part;
        double fractional_part = Math.modf(value/size, out integer_part) * size;

        var delta = size - fractional_part;

        return (int) (value + delta);
    }
    
    public bool has_fractional_part(float value) {
       return value != (int) value;
    }

    public string format_for_y_axis(string unit, float value) {
        string pattern = "%0.0f%s";
        if (has_fractional_part(value)) {
            pattern = "%0.2f%s";
        }
        return pattern.printf(value, unit);
    }

    private static int num_of_digits(int value) {
        var num_digits = 0;
        while (value != 0) {
            value /= 10;
            ++num_digits;
        }

        return num_digits;
    }
}