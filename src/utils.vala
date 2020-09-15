using Cairo;

namespace LiveChart { 

    public float cap(float value) {
        var num_digits = num_of_digits((int) value);
        // GLib.Math.exp10 yet not exist in MINGW library
        var size = Math.pow(10, (double) num_digits - 1);

        if (value % size == 0) {
            return value;
        }

        double integer_part;
        double fractional_part = Math.modf(value/size, out integer_part) * size;

        var delta = size - fractional_part;

        return (float) (value + delta);
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

    public Gee.List<float?> golden_divisors(float value) {
        //No golden divisors for 0
        if (value == 0) {
            return new Gee.ArrayList<float?>();
        }

        //Handle values below 1
        float factor = value < 10 ? cap(100 / value) : 1f;
        float working_value = value * factor;

        var sqrt = Math.sqrtf(working_value);
        var divs = new Gee.ArrayList<int>();

        for (int i = 1; i <= sqrt; i++) { 
            if (working_value % i == 0) {
                divs.add(i);
                float tmp = working_value / i;
                if (tmp != i) {
                    divs.add((int) tmp);
                }
            } 
        }
        divs.sort((a, b) => {
            return a - b;
        });

        var ndivs = new Gee.ArrayList<float?>();
        var last_div = divs.last();
        for (int i = divs.size - 1; i >= 0; i--) {
            var current = divs.get(i);
            if (last_div / current != 2) {
                continue;
            }
            ndivs.add((float) current);
            last_div = current;
        }

        return ndivs;
    }

    private int num_of_digits(int value) {
        var num_digits = 0;
        while (value != 0) {
            value /= 10;
            ++num_digits;
        }

        return num_digits;
    }
}
