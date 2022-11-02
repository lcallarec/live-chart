using Cairo;

namespace LiveChart { 
    public class SmoothLine : SerieRenderer {
        
        public Region? region {get; set; default = null; }
        protected Intersections intersections = new Intersections();
        public SmoothLine(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = Points.create(values, config);
                if(points.size > 0) {
                    
                    if (region != null) {
                        ctx.push_group();
                    }

                    this.draw_smooth_line(points, ctx, config);
                    ctx.stroke();

                    if (region != null) {
                        ctx.set_operator(Operator.ATOP);
                        this.draw_regions_on_line(ctx, config);
                        ctx.fill();
                        ctx.pop_group_to_source();
                        ctx.paint();
                    }
                }            
            }
        }

        public Cairo.Path draw_smooth_line(Points points, Context ctx, Config config) {
            this.intersections = new Intersections();
            var first_point = points.first();
            
            this.update_bounding_box(points, config);
            this.debug(ctx);

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
                if (this.region != null) {
                    this.generate_intersections(previous_point, target_point, config, curve);
                }
            }

            return ctx.copy_path();
        }

        protected void draw_regions_on_line(Context ctx, Config config) {
            var boundaries = config.boundaries();
            this.intersections.foreach((intersection) => {
                if (intersection != null) {
                    ctx.rectangle(intersection.start_x, boundaries.y.min, intersection.end_x - intersection.start_x, boundaries.height);
                    ctx.set_source_rgba(intersection.region.line_color.red, intersection.region.line_color.green, intersection.region.line_color.blue, intersection.region.line_color.alpha);
                }
                return true;
            });
        }

        private void generate_intersections(Point previous, Point target, Config config, BezierCurve curve) {
            new BezierIntersector(this.region, config).intersect(this.intersections, previous, target, curve);
        }

        private void update_bounding_box(Points points, Config config) {
            this.bounding_box = BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }
}