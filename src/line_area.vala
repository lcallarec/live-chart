using Cairo;

namespace LiveChart { 
    public class LineArea : Line {

        public double area_alpha {get; set; default = 0.1;}

        private LineAreaDrawer drawer = new LineAreaDrawer();

        public LineArea(Values values = new Values()) {
            base(values);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, Points.create(values, config), this.line, this.main_color, this.area_alpha);
            }
        }
    }

    public class LineAreaDrawer : Object {
        private LineDrawer drawer = new LineDrawer();
        public void draw(Context ctx, Config config, Points points, Path line, Gdk.RGBA color, double area_alpha) {
            if (points.size > 0) {
                drawer.draw(ctx, config, line, points);
                ctx.stroke_preserve();   

                var area = new Area(points, color, area_alpha);
                area.draw(ctx, config);
                ctx.fill();
            }
            //Avoid side-effects
            ctx.stroke();
        }
    }
}