using Cairo;

namespace LiveChart { 
    public class Line : SerieRenderer {

        public Region? region {get; set; default = null; }

        private LineSerieDrawer drawer = new LineSerieDrawer();

        public Line(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.line, Points.create(values, config), this.region);
            }
        }
    }

    public class LineSerieDrawer : Drawer {
        private LineDrawer drawer = new LineDrawer();
        private RegionOnLineDrawer region_on_line_drawer = new RegionOnLineDrawer();
        private LineIntersectionsGenerator intersections_generator = new LineIntersectionsGenerator();

        public void draw(Context ctx, Config config, Path line, Points points, Region? region) {
            if (points.size > 0) {
                drawer.draw(ctx, config, line, points);
                var segments = ctx.copy_path();
                
                
                if(region != null && region.has_line_color()) {
                    ctx.push_group();
                        ctx.stroke();
                        
                        ctx.set_operator(Operator.CLEAR);
                        region_on_line_drawer.draw(ctx, config, intersections_generator.generate(region, config, points));
                        ctx.fill();
                    
                    ctx.pop_group_to_source();
                    ctx.paint();
                    
                    ctx.push_group();

                        ctx.set_operator(Operator.SOURCE);
                        line.configure(ctx);
                        ctx.append_path(segments);
                        ctx.stroke();

                        ctx.set_operator(Operator.IN);
                        region_on_line_drawer.draw(ctx, config, intersections_generator.generate(region, config, points));
                        ctx.fill();
                    ctx.pop_group_to_source();
                    ctx.paint();
                    
                } else {
                    ctx.stroke();
                }
            }
        }
    }

    private class LineIntersectionsGenerator : Drawer {
        public Intersections generate(Region region, Config config, Points points) {
            var resolver = new CurveRegionResolver(region);
            var intersector = new SegmentIntersector(resolver, config);
    
            for (int pos = 0; pos <= points.size -1; pos++) {
                var previous_point = points.get(pos);
                var target_point = points.after(pos);
    
                if (this.is_out_of_area(previous_point)) {
                    continue;
                }
                intersector.intersect(previous_point, target_point, null);
            }

            return resolver.get_intersections();
        }
    }

    private class LineDrawer : Drawer {
        public void draw(Context ctx, Config config, Path line, Points points) {
            line.configure(ctx);
                
            var first_point = points.first();

            ctx.move_to(first_point.x, first_point.y);
            for (int pos = 0; pos < points.size -1; pos++) {
                var current_point = points.get(pos);
                var next_point = points.after(pos);
                if (this.is_out_of_area(current_point)) {
                    ctx.move_to(current_point.x, current_point.y);
                    continue;
                }

                ctx.line_to(next_point.x, next_point.y);
            }
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