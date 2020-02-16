void main (string[] args) {

    Test.init(ref args);

    register_geometry();
    register_limits();

    Test.run();
}