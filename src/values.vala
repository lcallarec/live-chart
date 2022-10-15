using Gee;

namespace LiveChart {
    
    public struct TimestampedValue {
        public double timestamp;
        public double value;
    }
    public class Values : LinkedList<TimestampedValue?> {

        public Bounds bounds {
            get; construct set;
        }
 
        private int buffer_size;
 
        public Values(int buffer_size = 1000) {
            this.bounds = new Bounds();
            this.buffer_size = buffer_size;
        }

        public new void add(TimestampedValue value) {
            if (this.size == buffer_size) {
                this.remove_at(0);
            }
            bounds.update(value.value);
            base.add(value);
        }
    }
}