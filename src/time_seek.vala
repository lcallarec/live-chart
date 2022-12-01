namespace LiveChart{
    
    public class TimeSeek {
        
        public int64 current;
        
        public int64 conv_us {get; private set;}
        public int64 conv_sec {get; private set;}
        private string fmt;
        
        public TimeSeek(){
            this.set_range("m");
            this.current = GLib.get_real_time() / this.conv_us;
        }
        
        public void set_range(string unit_sec){
            int64 prev_conv_us = this.conv_us;
            //int64 prev_conv_sec = this.conv_sec;

            switch(unit_sec){
            case "s":
                this.conv_us = 1000 * 1000;
                this.conv_sec = 1;
                this.fmt = "%s.%01lld";
                break;
            case "m":
                this.conv_us = 1000;
                this.conv_sec = 1000;
                this.fmt = "%s.%03lld";
                break;
            case "u":
                this.conv_us = 1;
                this.conv_sec = 1000 * 1000;
                this.fmt = "%s.%06lld";
                break;
            default:
                this.set_range("m");
                return;
            }
            
            this.current = (this.current * prev_conv_us) / this.conv_us;
            
        }
        
        public string get_time_str(int64 time, bool show_fraction){
            var t = time / this.conv_sec;
            var frac = time - t * this.conv_sec;
            if(frac < 0){
                frac += this.conv_sec;
                t -= 1;
            }
            
            var dtime = new DateTime.from_unix_local(t).format("%H:%M:%S");
            if(show_fraction){
                return this.fmt.printf(dtime, frac);
            }
            return dtime;
        }
        
    }
    
}