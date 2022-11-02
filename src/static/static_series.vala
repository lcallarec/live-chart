using Gee;
using LiveChart;

namespace LiveChart.Static { 

    public class StaticSeries : Object {

        private Gee.ArrayList<StaticSerie> series = new Gee.ArrayList<StaticSerie>();
        private StaticChart chart;

        public StaticSeries(StaticChart chart) {
            this.chart = chart;
        }

        public StaticSerie register(StaticSerie serie) {
            this.series.add(serie);
            // TODO if(chart.legend != null) chart.legend.add_legend(serie);
            serie.value_added.connect((value) => {
                
                chart.config.y_axis.update_bounds(value);
            });
            return serie;
        }

        public new StaticSerie get(int index) throws ChartError {
            if (index > series.size - 1) {
                throw new ChartError.SERIE_NOT_FOUND("Serie at index %d not found".printf(index));
            }
            return series.get(index);
        }

        public StaticSerie get_by_name(string name) throws ChartError {
            foreach (StaticSerie serie in series) {
                if (serie.name == name) return serie;
            }
            throw new ChartError.SERIE_NOT_FOUND("Serie with name %s not found".printf(name));
        }

        public Iterator<StaticSerie> iterator() {
            return series.list_iterator();
        }
    }
}