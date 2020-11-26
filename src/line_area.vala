using Cairo;

namespace LiveChart { 
    public class LineArea : Line {

        public double area_alpha {get; set; default = 0.1;}
        private PointsFactory<TimestampedValue?> points_factory;
        public LineArea(Values values = new Values()) {
            base(values);
            points_factory = new TimeStampedPointsFactory(values);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = points_factory.create(config);
                if (points.size > 0) {
                    draw_line(points, ctx, config);
                    ctx.stroke_preserve();   
    
                    var area = new Area(points, this.main_color, this.area_alpha);
                    area.draw(ctx, config);
                }
                //Avoid side-effects
                ctx.stroke();
            }
        }
    }
}