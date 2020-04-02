using Cairo;

namespace LiveChart { 

    public float cap(float value) {
        var num_digits = num_of_digits((int) value);
        var size = Math.exp10((double) num_digits - 1);

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

    public Gee.List<int> golden_divisors(float value) {
        var sqrt = Math.sqrtf(value);
        var divs = new Gee.ArrayList<int>();
        for (int i = 1; i <= sqrt; i++) { 
            if (value % i == 0) {
                divs.add(i);
                float tmp = value / i;
                if (tmp != i) {
                    divs.add((int) tmp);
                }
            } 
        }
        divs.sort((a, b) => {
            return a - b;
        });

        var ndivs = new Gee.ArrayList<int>();
        var last_div = divs.last();
        for (int i = divs.size - 1; i >= 0; i--) {
            var current = divs.get(i);
            if (last_div / current != 2) {
                continue;
            }
            ndivs.add(current);
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