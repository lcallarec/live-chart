void main (string[] args) {

    Test.init(ref args);
    Gtk.init(ref args);

    register_config();
    register_bounds();
    register_values();
    register_points();
    register_chart();
    register_axis();
    register_line_area();
    
    Test.run();
}