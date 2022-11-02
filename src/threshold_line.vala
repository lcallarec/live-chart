using Cairo;

namespace LiveChart { 
    
    public class ThresholdLine : SerieRenderer {
        
        public double value { get; set; default = 0;}
        
        public ThresholdLine(double value) {
            base();
            this.value = value;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var boundaries = config.boundaries();
                line.configure(ctx);
                var y = boundaries.y.max - (value * config.y_axis.get_ratio());
                ctx.move_to((double) boundaries.x.min, y);
                ctx.line_to((double) boundaries.x.max, y);
                ctx.stroke();
            }
        }
    }
}