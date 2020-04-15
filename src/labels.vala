using Cairo;

namespace LiveChart {

    public class Labels {

        public bool visible {get; set; }
        public TextExtents extents { get; set; }
        public Font font { get; set; }

        public Labels() {

            visible = true;
            extents = TextExtents();
            font = new Font();

            extents.height = 0.0;
            extents.width = 0.0;
            extents.x_advance = 0.0;
            extents.x_bearing = 0.0;
            extents.y_advance = 0.0;
            extents.y_bearing  = 0.0;
        }
    }
}