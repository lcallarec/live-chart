void main (string[] args) {

    Test.init(ref args);
    Gtk.init(ref args);

    register_config();
    register_bounds();
    register_values();
    register_points();
    register_chart();
    register_axis();
    register_area();
    register_line_area();
    register_line();
    register_smooth_line();
    register_smooth_line_area();
    register_bar();
    register_utils();
    register_grid();
    register_background();
    register_legend();
    register_cairo();
    register_serie();

    Test.run();
}