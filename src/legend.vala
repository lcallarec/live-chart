using Cairo;

namespace LiveChart {
    
    public interface LegendAware : Object {
        public abstract void add_legend(Serie serie);
    }

    public abstract class Legend : Drawable, LegendAware, Object {

        protected Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }
        public void add_legend(Serie serie) {
            series.add(serie);
        }

        public abstract void draw(Context ctx, Config config);
        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
    }

     public class HorizontalLegend : Legend {
        
        private const int COLOR_BLOCK_WIDTH = 15;

        public override void draw(Context ctx, Config config) {
            var boundaries = config.boundaries();
            var pos = 0;
            series.foreach((serie) => {
                ctx.set_source_rgba(serie.get_main_color().red, serie.get_main_color().green, serie.get_main_color().blue, 1);
                ctx.rectangle(boundaries.x.min + pos, boundaries.y.max + 22, HorizontalLegend.COLOR_BLOCK_WIDTH, 10);
                ctx.fill();

                ctx.move_to(boundaries.x.min + pos + HorizontalLegend.COLOR_BLOCK_WIDTH + 3, boundaries.y.max + 20 + Config.FONT_SIZE);
                ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);
                ctx.show_text(serie.name);
                pos += HorizontalLegend.COLOR_BLOCK_WIDTH + (int) name_extents(serie.name, ctx).width + 20;

                return true;
            });
            ctx.stroke();
            this.update_bounding_box(boundaries, pos);
            this.debug(ctx);
        }

        private TextExtents name_extents(string name, Context ctx) {
            TextExtents name_extents;
            ctx.text_extents(name, out name_extents);

            return name_extents;
        }

        private void update_bounding_box(Boundaries boundaries, int width) {
            this.bounding_box = BoundingBox() {
                x=boundaries.x.min,
                y=boundaries.y.max + 22,
                width=width,
                height=10
            };
        }

        protected void debug(Context ctx) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }        
    }

    public class NoopLegend : Legend {
        public override void draw(Context ctx, Config config) {}
    }
}