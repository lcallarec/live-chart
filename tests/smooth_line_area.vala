private void register_smooth_line_area() {
    
    Test.add_func("/SmoothLineArea/should_not_render_if_no_values", () => {
        //Given
        var context = create_context();

        var values = new LiveChart.Values();
       
        var line = new LiveChart.SmoothLineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        line.draw(context.ctx, create_config());
        screenshot(context);

        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });   

    Test.add_func("/SmoothLineArea/should_render_a_smooth_line_with_area_below", () => {
        //Given
        var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };

        var context = create_context(43, 20);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
       
        var line = new LiveChart.SmoothLineArea(values);
        line.line.color = green;
        line.area_alpha = 0.5f;

        //When
        line.draw(context.ctx, create_config(43, 20));
        screenshot(context);

        //Then the curve colors are...
        assert(get_color_at(context)({x: 0, y: 14}) == green);
        assert(get_color_at(context)({x: 22, y: 0}) == green);
        assert(get_color_at(context)({x: 42, y: 14}) == green);

        //And below the curve, color is...
        var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };
        assert(get_color_at(context)({x: 22, y: 7}).equal(flattened_area_color));
    });   

    Test.add_func("/SmoothLineArea/Regions", () => {
        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_plain_line_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 1f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(red);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            //Then the curve colors are...
            assert(get_color_at(context)({x: 0, y: 14}) == red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == red);

            //And below the curve, color is still a semi-transparent green
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(flattened_area_color));
        });
        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_semi_transparent_line_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var transparent_red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 0.5f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(transparent_red);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            var flattened_transparent_red = Gdk.RGBA() { red = 1f, green = 0.5f, blue = 0.5f, alpha = 1f };
            //Then the curve colors are...
            assert(get_color_at(context)({x: 0, y: 14}) == flattened_transparent_red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == flattened_transparent_red);

            //And below the curve, color is...
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(flattened_area_color));
        });

        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_plain_area_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 1f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_area_color(red);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            //Then the area color is...
            var flattened_green = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(red));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_green));
            assert(get_color_at(context)({x: 42, y: 18}).equal(red));

            //And the curve colors are...
            assert(get_color_at(context)({x: 0, y: 14}) == green);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == green);
        });

        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_semi_transparent_area_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var transparent_red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 0.5f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(transparent_red);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            var flattened_transparent_red = Gdk.RGBA() { red = 1f, green = 0.5f, blue = 0.5f, alpha = 1f };

            //Then the curve colors are...
            assert(get_color_at(context)({x: 0, y: 14}) == flattened_transparent_red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == flattened_transparent_red);

            //And below the curve, color is still a semi-transparent green
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(flattened_area_color));
        });

        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_plain_line_and_plain_area_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 1f };
            var blue = Gdk.RGBA() { red = 0.0f, green = 0f, blue = 1.0f, alpha = 1f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(red).with_area_color(blue);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            //Then the curve colors are...
            assert(get_color_at(context)({x: 0, y: 14}) == red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == red);

            //And below the curve, color is still a semi-transparent green
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(blue));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(blue));
        });

        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_semi_transparent_line_and_semi_transparent_area_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var transparent_red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 0.5f };
            var transparent_blue = Gdk.RGBA() { red = 0.0f, green = 0f, blue = 1.0f, alpha = 0.5f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(transparent_red).with_area_color(transparent_blue);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);

            //Then the curve colors are...
            var flattened_transparent_red = Gdk.RGBA() { red = 1f, green = 0.5f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 14}) == flattened_transparent_red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == flattened_transparent_red);

            //And below the curve, color is still a semi-transparent green
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };
            var flattened_transparent_blue = Gdk.RGBA() { red = 0.5f, green = 0.5f, blue = 1f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(flattened_transparent_blue));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(flattened_transparent_blue));
        });

        Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_semi_transparent_line_and_plain_area_region", () => {
            //Given
            var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };
            var transparent_red = Gdk.RGBA() { red = 1.0f, green = 0f, blue = 0.0f, alpha = 0.5f };
            var blue = Gdk.RGBA() { red = 0.0f, green = 0f, blue = 1.0f, alpha = 1f };

            var context = create_context(43, 20);

            var values = new LiveChart.Values();
            values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
            values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
            values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
            
            var line = new LiveChart.SmoothLineArea(values);
            line.region = new LiveChart.Region.between(3, 10).with_line_color(transparent_red).with_area_color(blue);
            line.line.color = green;
            line.area_alpha = 0.5f;

            //When
            line.draw(context.ctx, create_config(43, 20));
            screenshot(context);
            
            //Then the curve colors are...
            var flattened_transparent_red = Gdk.RGBA() { red = 1f, green = 0.5f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 14}) == flattened_transparent_red);
            assert(get_color_at(context)({x: 22, y: 0}) == green);
            assert(get_color_at(context)({x: 42, y: 14}) == flattened_transparent_red);

            //And below the curve, color is still a semi-transparent green
            var flattened_area_color = Gdk.RGBA() { red = 0.5f, green = 1f, blue = 0.5f, alpha = 1f };

            assert(get_color_at(context)({x: 0, y: 18}).equal(blue));
            assert(get_color_at(context)({x: 22, y: 18}).equal(flattened_area_color));
            assert(get_color_at(context)({x: 42, y: 18}).equal(blue));
        });
    });    
}