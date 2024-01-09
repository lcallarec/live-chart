using Cairo;

namespace LiveChart {
     public class SmoothLineArea : SmoothLine {

        public double area_alpha {get; set; default = 0.1;}
        private SmoothLineAreaDrawer drawer = new SmoothLineAreaDrawer();

        public SmoothLineArea(Values values = new Values()) {
            base(values);
        }
        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.line, Points.create(values, config),this.main_color, this.area_alpha, this.region);
            }
        }
    }

    public class SmoothLineRegionAreaDrawer {
        public void draw(Context ctx, Config config, Intersections intersections) {
            var boundaries = config.boundaries();
            intersections.foreach((intersection) => {
                if (intersection != null) {
                    ctx.rectangle(intersection.start_x, boundaries.y.min, intersection.end_x - intersection.start_x, boundaries.height);
                    ctx.set_source_rgba(intersection.region.area_color.red, intersection.region.area_color.green, intersection.region.area_color.blue, intersection.region.area_color.alpha);
                    ctx.fill();
                }
                return true;
            });
        }
    }

    public class SmoothLineAreaDrawer {

        private SmoothLineRegionAreaDrawer region_drawer = new SmoothLineRegionAreaDrawer();
        private SmoothLineRegionOnLineDrawer region_on_line_drawer = new SmoothLineRegionOnLineDrawer();
        private SmoothLineLineDrawer smooth_line_drawer = new SmoothLineLineDrawer();

        public void draw(Context ctx, Config config, Path line, Points points, Gdk.RGBA color, double alpha, Region? region) {
            if(points.size > 0) {
                ctx.push_group();
                    var intersections = smooth_line_drawer.draw(ctx, config, line, points, region);
                    var path = ctx.copy_path();

                    ctx.stroke_preserve();

                    var area = new Area(points, color, alpha);
                    area.draw(ctx, config);
                    ctx.fill();
                
                    ctx.set_operator(Operator.ATOP);
                    region_on_line_drawer.draw(ctx, config, intersections);
                    ctx.fill();
                ctx.pop_group_to_source();

                ctx.save();
                    ctx.append_path(path);
                    area.draw(ctx, config);
                    ctx.clip();
                
                    region_drawer.draw(ctx, config, intersections);
                ctx.restore();
                ctx.paint();
            }
        }
    }
}