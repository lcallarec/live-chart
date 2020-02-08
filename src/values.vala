using Gee;

namespace LiveChart {
    
    public class Values : Object {

        private Gee.ArrayList<TimestampedValue?> values = new Gee.ArrayList<TimestampedValue?>();

        public int size {
            get {
                return values.size;
            }
        }

        public void add(TimestampedValue value) {
            values.add(value);
        }

        public new TimestampedValue get(int at) {
            return values.get(at);
        }

        public TimestampedValue after(int at) {
            if (at == size - 1) return this.get(at);
            return this.get(at + 1);
        }

        public TimestampedValue last() {
            return this.get(this.size - 1);
        }
    }
}