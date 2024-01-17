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
        private SmoothLineInterectionsGenerator intersections_generator = new SmoothLineInterectionsGenerator();

        public void draw(Context ctx, Config config, Path line, Points points, Region? region) {
            if(points.size > 0) {
                var curves = line_drawer.draw(ctx, config, line, points, region);
                if (region != null) {
                    ctx.push_group();
                }

                ctx.stroke();

                if (region != null) {
                    ctx.set_operator(Operator.ATOP);
                    region_on_line_drawer.draw(ctx, config, intersections_generator.generate(region, config, points, curves));
                    ctx.fill();
                    ctx.pop_group_to_source();
                    ctx.paint();
                }
            }
        }
    }
    
    private class SmoothLineInterectionsGenerator : Drawer {
        public Intersections generate(Region region, Config config, Points points, Gee.List<BezierCurve?> curves ) {
            var resolver = new SmoothLineRegionResolver(region);
            var intersector = new BezierIntersector(resolver, config);
    
            for (int pos = 0; pos <= points.size -1; pos++) {
                var previous_point = points.get(pos);
                var target_point = points.after(pos);
    
                if (this.is_out_of_area(previous_point)) {
                    continue;
                }
                intersector.intersect(previous_point, target_point, curves.get(pos));
            }
    
            return resolver.get_intersections();
        }
    }

    private class SmoothLineDrawer : Drawer {

        public Gee.ArrayList<BezierCurve?> draw(Context ctx, Config config, Path line, Points points, Region? region) {
          
            var first_point = points.first();
            
            ctx.move_to(first_point.x, first_point.y);
            line.configure(ctx);

            var curves = new Gee.ArrayList<BezierCurve?>();

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

                curves.add(curve);
            }

            return curves;
        }
    }

    private class RegionOnLineDrawer {
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