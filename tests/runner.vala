void main (string[] args) {

    Test.init(ref args);
    Gtk.init(ref args);

    register_geometry();
    register_bounds();
    register_values();
    register_points();
    register_chart();
    
    Test.run();
}