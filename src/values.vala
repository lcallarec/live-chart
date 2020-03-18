using Gee;

namespace LiveChart {
    
    public class Values : Object {

        private Gee.ArrayList<TimestampedValue?> values = new Gee.ArrayList<TimestampedValue?>();
        private int buffer_size;
        public int size {
            get {
                return values.size;
            }
        }

        public Values(int buffer_size = 1000) {
            this.buffer_size = buffer_size;
        }

        public void add(TimestampedValue value) {
            if (this.size == buffer_size) {
                values.remove_at(0);
            }
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