# Live Chart

**Live Chart** is a real-time charting library for GTK3 and Vala, based on [Cairo](https://cairographics.org/).

## Features

Live chart, as its name imply, aims to render real-time series.

* Render many series withing a single chart
* Automatic y-axis adjustement
* Support chart area / window live resizing
* Extendable

## Screenshots

![animated_chart](docs/animated.gif)
![chart_1](docs/chart1.png)

## Example 

Example source code available [here](examples/live-chart.vala)

Compile and run with (you need to have cario-dev installed)

```bash
$ make
```

```vala
public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Live Chart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(500, 500);

        var rss = new LiveChart.Serie("rss");
        rss.line = new LiveChart.Line();
        rss.line.color = { 0.8, 0.1, 0.1, 1.0};

        var heap = new LiveChart.Serie("heap");
        heap.line = new LiveChart.Line();
        heap.line.color = { 0.8, 0.1, 0.1, 1.0};

        var chart = new LiveChart.Chart();
        chart.serie(rss);
        chart.serie(heap);
        
        this.add(chart);

        var rss_value = 300.0;
        chart.add_point("rss", rss_value);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.0) {
                var new_value = Random.double_range(-20, 20.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            chart.add_point("rss", rss_value);
            return true;
        });

        var heap_value = 100.0;
        chart.add_point("heap", heap_value);
        Timeout.add(5000, () => {
            if (Random.double_range(0.0, 1.0) > 0.8) {
                var new_value = Random.double_range(-10, 10.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            chart.add_point("heap", heap_value);
            return true;
        });
     }
}

```