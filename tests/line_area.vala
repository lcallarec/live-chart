private void register_line_area() {
    Test.add_func("/LiveChart/LineArea/Draw", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var values = new LiveChart.Values();
        //Two points to draw an horizontal line
        values.add({timestamp: (GLib.get_real_time() / 1000) - 10000, value: 5.5});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5.5});

        var line = new LiveChart.LineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        line.area_alpha = 0.5;

        //When
        line.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //Fourth pixels row, before the red line : 
            for(var i = 3 * stride; i < 4 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Fifth pixels row, the red line :             
            for(var i = 4 * stride; i < 5 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r ==255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Sixth pixels row, the area (50% red)               
            for(var i = 5 * stride; i < 6 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 128);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/LineArea/Draw#shouldnt_render_if_no_values", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var values = new LiveChart.Values();
       
        var line = new LiveChart.LineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        line.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are black, nothing has been rendered
            for(var i = 0 * stride; i < SURFACE_HEIGHT * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });
    
    Test.add_func("/LiveChart/LineArea/Draw#should_render_all_points", () => {
        //Given
        var WIDTH = 100;
        var HEIGHT = 100;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context, {0, 0, 0, 1}, WIDTH, HEIGHT);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 0});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 100});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 0});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 10800, value: 100});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 14400, value: 0});

        var area = new LiveChart.LineArea(values);
          
        area.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 0.5 };
        area.area_alpha = 0.5;

        //When
        area.draw(context, create_config(WIDTH, HEIGHT));
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT) ;

        assert(color_at(pixbuff)(35, 50).to_string() == "rgb(128,0,0)");
        assert(color_at(pixbuff)(57, 50).to_string() == "rgb(0,0,0)");
        assert(color_at(pixbuff)(80, 50).to_string() == "rgb(128,0,0)");
    });
  
}

[Version (experimental=true)]
private void register_experimental_line_area() {

    Test.add_func("/LiveChart/LineAreaSerie/draw", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var line = new LiveChart.LineAreaSerie("Test");
        //Two points to draw an horizontal line
        line.add_with_timestamp(5.5, (GLib.get_real_time() / 1000) - 10000);
        line.add_with_timestamp(5.5, (GLib.get_real_time() / 1000));
        
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        line.area_alpha = 0.5;

        //When
        line.draw(context, create_config());
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT);
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            
            //Fourth pixels row, before the red line : 
            for(var i = 3 * stride; i < 4 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Fifth pixels row, the red line :             
            for(var i = 4 * stride; i < 5 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r ==255);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }

            //Sixth pixels row, the area (50% red)               
            for(var i = 5 * stride; i < 6 * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 128);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });

    Test.add_func("/LiveChart/LineAreaSerie/draw#shouldnt_render_if_no_values", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);
      
        var line = new LiveChart.LineAreaSerie("Test");
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        line.draw(context, create_config());
         
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, SURFACE_WIDTH, SURFACE_HEIGHT) ;
        if (pixbuff != null) {
            unowned uint8[] data = pixbuff.get_pixels_with_length();
            var stride = pixbuff.rowstride;
            // Every pixels are black, nothing has been rendered
            for(var i = 0 * stride; i < SURFACE_HEIGHT * stride; i=i+pixbuff.bits_per_sample ) {
                var r = data[i];
                var g = data[i + 1];
                var b = data[i + 2];
                var alpha = data[i + 3];

                assert(r == 0);
                assert(g == 0);
                assert(b == 0);
                assert(alpha == 255);
            }
        } else {
            assert_not_reached();
        }
    });
    
    Test.add_func("/LiveChart/LineAreaSerie/draw#should_render_all_points", () => {
        //Given
        var WIDTH = 100;
        var HEIGHT = 100;
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context, {0, 0, 0, 1}, WIDTH, HEIGHT);

        var area = new LiveChart.LineAreaSerie("Test");
        area.add_with_timestamp(0, (GLib.get_real_time() / 1000));
        area.add_with_timestamp(100, (GLib.get_real_time() / 1000) - 3600);
        area.add_with_timestamp(0, (GLib.get_real_time() / 1000) - 7200);
        area.add_with_timestamp(100, (GLib.get_real_time() / 1000) - 10800);
        area.add_with_timestamp(0, (GLib.get_real_time() / 1000) - 14400);
        
        area.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 0.5 };
        area.area_alpha = 0.5;

        //When
        area.draw(context, create_config(WIDTH, HEIGHT));
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT) ;

        assert(color_at(pixbuff)(35, 50).to_string() == "rgb(128,0,0)");
        assert(color_at(pixbuff)(57, 50).to_string() == "rgb(0,0,0)");
        assert(color_at(pixbuff)(80, 50).to_string() == "rgb(128,0,0)");
    });   
}
