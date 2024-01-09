using Cairo;

namespace LiveChart {
    
     public abstract class Legend : Drawable, Object {

        public bool visible { get; set; default = true; }
        public Labels labels = new Labels();

        protected Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();

        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0f,
                green = 1.0f,
                blue = 1.0f,
                alpha = 1.0f
            };
        }
        public void add_legend(Serie serie) {
            series.add(serie);
        }
        public void remove_legend(Serie serie){
            if(series.contains(serie)){
                series.remove(serie);
            }
        }
        public void remove_all_legend(){
            series.clear();
        }
        
        public abstract void draw(Context ctx, Config config);
        public abstract BoundingBox get_bounding_box(Config config);
    }

     public class HorizontalLegend : Legend {

        private HorizontalLegendDrawer drawer = new HorizontalLegendDrawer();
        private int legend_width = 0;

        public override void draw(Context ctx, Config config) {
            if (visible) {
                legend_width = drawer.draw(ctx, config, this.series, this.labels);
            }
        }

        public override BoundingBox get_bounding_box(Config config) {
            return drawer.get_bounding_box(config, legend_width);
        }
    }

    public class HorizontalLegendDrawer : Object {

        private const int COLOR_BLOCK_WIDTH = 15;
        private const int COLOR_BLOCK_HEIGHT = 10;

        public int draw(Context ctx, Config config, Gee.ArrayList<Serie> series, Labels labels) {
            var y_padding = get_y_padding(config);
            var boundaries = config.boundaries();
            var pos = 0;
            series.foreach((serie) => {
                ctx.set_source_rgba(serie.main_color.red, serie.main_color.green, serie.main_color.blue, 1);
                ctx.rectangle(boundaries.x.min + pos, boundaries.y.max + y_padding, HorizontalLegendDrawer.COLOR_BLOCK_WIDTH, HorizontalLegendDrawer.COLOR_BLOCK_HEIGHT);
                ctx.fill();
                
                labels.font.configure(ctx);
                TextExtents extents = name_extents(serie.name, ctx);
                ctx.move_to(boundaries.x.min + pos + HorizontalLegendDrawer.COLOR_BLOCK_WIDTH + 3, boundaries.y.max + y_padding + extents.height + (HorizontalLegendDrawer.COLOR_BLOCK_HEIGHT - extents.height) / 2);
                ctx.show_text(serie.name);

                pos += HorizontalLegendDrawer.COLOR_BLOCK_WIDTH + (int) extents.width + 20;

                return true;
            });
            ctx.stroke();

            return pos;
        }
        
        public BoundingBox get_bounding_box(Config config, int width) {
            var boundaries = config.boundaries();
            return BoundingBox() {
                x = boundaries.x.min,
                y = boundaries.y.max + get_y_padding(config),
                width = width,
                height = 10
            };
        }

        private int get_y_padding(Config config) {
            return (int) (Grid.ABSCISSA_TIME_PADDING * 2 + config.x_axis.labels.extents.height);
        }

        private TextExtents name_extents(string name, Context ctx) {
            TextExtents name_extents;
            ctx.text_extents(name, out name_extents);

            return name_extents;
        }
    }

    public class NoopLegend : Legend {
        public override void draw(Context ctx, Config config) {}
        public override BoundingBox get_bounding_box(Config config) {
            return BoundingBox() {
                x = 0,
                y = 0,
                width = 0,
                height = 0
            };
        }

    }
}