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
                ctx.move_to((double) boundaries.x.min, boundaries.y.max - (value * config.y_axis.get_ratio()));
                ctx.line_to((double) boundaries.x.max, boundaries.y.max - (value * config.y_axis.get_ratio()));
                ctx.stroke();
            }
        }
    }
}