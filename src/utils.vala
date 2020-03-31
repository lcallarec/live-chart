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

    private static int num_of_digits(int value) {
        var num_digits = 0;
        while (value != 0) {
            value /= 10;
            ++num_digits;
        }

        return num_digits;
    }
}