using Cairo;

namespace LiveChart {
     public class SmoothLineArea : SmoothLine {

        public double area_alpha {get; set; default = 0.1;}

        public override void draw(Context ctx, Config config) {
            var points = Points.create(values, config);
            
            this.draw_smooth_line(points, ctx, config);
            ctx.stroke_preserve();
           
            var area = new Area(points, this.main_color, this.area_alpha);
            area.draw(ctx, config);
        }
    }
}