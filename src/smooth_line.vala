using Cairo;

namespace LiveChart { 

    public class SmoothLine : SerieRenderer {
        
        public Region? region {get; set; default = null; }
        private SmoothLineSerieDrawer drawer = new SmoothLineSerieDrawer();

        public SmoothLine(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.line, Points.create(values, config), this.region);    
            }
        }
    }

    public class SmoothLineSerieDrawer : Drawer {
        private SmoothLineDrawer line_drawer = new SmoothLineDrawer();
        private RegionOnLineDrawer region_on_line_drawer = new RegionOnLineDrawer();

        public Intersections draw(Context ctx, Config config, Path line, Points points, Region? region) {
            if(points.size > 0) {
                var intersections = line_drawer.draw(ctx, config, line, points, region);
                if (region != null) {
                    ctx.push_group();
                }

                ctx.stroke();

                if (region != null) {
                    ctx.set_operator(Operator.ATOP);
                    region_on_line_drawer.draw(ctx, config, intersections);
                    ctx.fill();
                    ctx.pop_group_to_source();
                    ctx.paint();
                }
                return intersections;
            }

            return new Intersections();
        }
    }

    public class SmoothLineDrawer : Drawer {
        public Intersections draw(Context ctx, Config config, Path line, Points points, Region? region) {
            var intersections = new Intersections();

            var first_point = points.first();
            
            ctx.move_to(first_point.x, first_point.y);
            line.configure(ctx);

            for (int pos = 0; pos <= points.size -1; pos++) {
                
                var previous_point = points.get(pos);
                var target_point = points.after(pos);

                if (this.is_out_of_area(previous_point)) {
                    continue;
                }
                
                var curve = build_bezier_curve_from_points(previous_point, target_point);

                ctx.curve_to(
                    curve.c1.x, curve.c1.y,
                    curve.c2.x, curve.c2.y,
                    curve.c3.x, curve.c3.y
                );

                if (region != null) {
                    generate_intersections(previous_point, target_point, config, curve, intersections, region);
                }
            }
            
            return intersections;
        }

        private void generate_intersections(Point previous, Point target, Config config, BezierCurve curve, Intersections intersections, Region region) {
            new BezierIntersector(region, config).intersect(new SmoothLineRegionResolver(region, intersections), previous, target, curve);
        }
    }

    public class RegionOnLineDrawer {
        public void draw(Context ctx, Config config, Intersections intersections) {
            var boundaries = config.boundaries();
            intersections.foreach((intersection) => {
                if (intersection != null) {
                    ctx.set_source_rgba(intersection.region.line_color.red, intersection.region.line_color.green, intersection.region.line_color.blue, intersection.region.line_color.alpha);
                    ctx.rectangle(intersection.start_x, boundaries.y.min, intersection.end_x - intersection.start_x, boundaries.height);
                }
                return true;
            });
        }
    }
}