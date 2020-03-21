
private void register_chart() {

    Test.add_func("/LiveChart/Chart#Export", () => {
        //given
        var window = new Gtk.Window();
        var chart = new LiveChart.Chart(new LiveChart.Config());
        window.add(chart);
        window.show();
        window.resize(50, 50);
        chart.show_all();
 
        //when
        try {
            chart.to_png("export.png");
        } catch (Error e) {
            assert_not_reached() ;
        }
        
        //then
        File file = File.new_for_path("export.png");
        assert(true == file.query_exists());
    });

    Test.add_func("/LiveChart/Chart#ExportWhenNotRealized", () => {
        //given
        var chart = new LiveChart.Chart(new LiveChart.Config());

        //when //then
        try {
            chart.to_png("export.png");
            assert_not_reached();
        } catch (Error e) {
            assert(e is LiveChart.ChartError.EXPORT_ERROR);
        }
    });
}