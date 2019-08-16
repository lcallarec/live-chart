namespace LiveChart { 
    public class Line : Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }

        public double line_width { get; set; default = 1;}
    }
}