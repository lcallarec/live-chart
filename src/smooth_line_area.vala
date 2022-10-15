using Cairo;

namespace LiveChart {
     public class SmoothLineArea : SmoothLine {

        public double area_alpha {get; set; default = 0.1;}

        public SmoothLineArea(Values values = new Values()) {
            base(values);
        }
        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = Points.create(values, config);
                if(points.size > 0) {

                    ctx.push_group();
                        var path = this.draw_smooth_line(points, ctx, config);
                        ctx.stroke_preserve();

                        var area = new Area(points, this.main_color, this.area_alpha);
                        area.draw(ctx, config);
                        ctx.fill();
                    
                        ctx.set_operator(Operator.ATOP);
                        this.draw_regions_on_line(ctx, config);
                        ctx.fill();
                    ctx.pop_group_to_source();

                    ctx.save();
                        ctx.append_path(path);
                        area.draw(ctx, config);
                        ctx.clip();
                    
                        this.draw_regions_on_area(ctx, config);
                    ctx.restore();
                    ctx.paint();

                }
            }
        }

        protected void draw_regions_on_area(Context ctx, Config config) {
            var boundaries = config.boundaries();
            this.intersections.foreach((intersection) => {
                if (intersection != null) {
                    ctx.rectangle(intersection.start_x, boundaries.y.min, intersection.end_x - intersection.start_x, boundaries.height);
                    ctx.set_source_rgba(intersection.region.area_color.red, intersection.region.area_color.green, intersection.region.area_color.blue, intersection.region.area_color.alpha);
                    ctx.fill();
                }
                return true;
            });
        }
    }
}