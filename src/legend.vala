using Cairo;

namespace LiveChart {
    
    public interface LegendAware : Object {
        public abstract void add_legend(Serie serie);
    }

    public abstract class Legend : Drawable, LegendAware, Object {

        protected Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();

        public void add_legend(Serie serie) {
            series.add(serie);
        }

        public abstract void draw(Bounds bounds, Context ctx, Geometry geometry);
    }

     public class HorizontalLegend : Legend {
        
        private const int COLOR_BLOCK_WIDTH = 15;

        public override void draw(Bounds bounds, Context ctx, Geometry geometry) {
            var boundaries = geometry.boundaries();
            var pos = 0;
            series.foreach((serie) => {
                ctx.set_source_rgba(serie.get_main_color().red, serie.get_main_color().green, serie.get_main_color().blue, 1);
                ctx.rectangle(boundaries.x.min + pos, boundaries.y.max + 22, HorizontalLegend.COLOR_BLOCK_WIDTH, 10);
                ctx.fill();
                
                ctx.move_to(boundaries.x.min + pos + HorizontalLegend.COLOR_BLOCK_WIDTH + 3, boundaries.y.max + 20 + Geometry.FONT_SIZE);
                ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);
                ctx.show_text(serie.name);
                pos += 100;

                return true;
            });
            ctx.stroke();
        }
    }

    public class NoopLegend : Legend {
        public override void draw(Bounds bounds, Context ctx, Geometry geometry) {}
    }
}