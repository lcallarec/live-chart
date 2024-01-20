using Cairo;

namespace LiveChart { 
    public class Bar : SerieRenderer {

        public Region? region {get; set; default = null; }
        
        private BarDrawer drawer = new BarDrawer();

        public Bar(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, Points.create(values, config), line, region);
            }
        }
    }

    public class BarDrawer : Object {

        private BarRegionResolver resolver = new BarRegionResolver();

        public void draw(Context ctx, Config config, Points points, Path line, Region? region) {
            if (points.size > 0) {
                for (int pos = 0; pos <= points.size - 1; pos++) {
                    var current_point = points.get(pos);
                    var next_point = points.after(pos);
                    
                    if (current_point.x < config.padding.left) {
                        continue;
                    }
                    
                    if(region != null && resolver.is_within(region, current_point.data.value)) {
                        ctx.set_source_rgba(region.area_color.red, region.area_color.green, region.area_color.blue, region.area_color.alpha);
                    } else {
                        line.configure(ctx);
                    }
                    
                    var bar_width = (current_point.x - next_point.x) / 1.2;
                    ctx.rectangle(next_point.x, next_point.y, bar_width, next_point.height);
                    ctx.fill();
                }
            }
        }
    }

    public class BarRegionResolver {
        public bool is_within(Region region, double value) {
            return value >= region.floor && value <= region.ceil;
        }
    }
}