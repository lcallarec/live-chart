using Gee;

namespace LiveChart {
    
    public class Values : LinkedList<TimestampedValue?> {

        private int buffer_size;
 
        public Values(int buffer_size = 1000) {
            this.buffer_size = buffer_size;
        }

        public new void add(TimestampedValue value) {
            if (this.size == buffer_size) {
                this.remove_at(0);
            }
            base.add(value);
        }
    }
}