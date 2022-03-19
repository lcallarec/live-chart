using Gee;

namespace LiveChart {
    
    public struct TimestampedValue {
        public double timestamp;
        public double value;
    }

    public class Values : TreeSet<TimestampedValue?> {
        public Bounds bounds {
            get; construct set;
        }
 
        private int buffer_size;
        
        private static int cmp(TimestampedValue? a, TimestampedValue? b){
            double r = a.timestamp - b.timestamp;
            if(r < 0.0){
                return -1;
            }
            if(r > 0.0){
                return 1;
            }
            return 0;
        }
        public Values(int buffer_size = 1000) {
            base(cmp);
            this.bounds = new Bounds();
            this.buffer_size = buffer_size;
        }
/*
        public new TimestampedValue @get(int index){
            assert (index >= 0);
            assert (index < buffer_size);
            int i = 0;
            TimestampedValue ret = {};
            this.foreach((v) => {
                if(i == index){
                    ret = v;
                    return false;
                }
                i++;
                return true;
            });
            return ret;
        }
        
*/
        public new void add(TimestampedValue value) {
            if (this.size == buffer_size) {
                //this.remove_at(0);
                this.remove(this.first());
            }
            bounds.update(value.value);
            base.add(value);
        }
    }
}