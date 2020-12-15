using Gee;
namespace LiveChart { 

    public class Series {

        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();
        private Chartable chart;

        public Series(Chartable chart) {
            this.chart = chart;
        }

        public Serie register(Serie serie) {
            this.series.add(serie);
            //if values were added to serie before registration
            serie.get_values().foreach((value) => {chart.config.y_axis.update_bounds(value.value); return true;});
            
            if(chart.legend != null) chart.legend.add_legend(serie);
            serie.value_added.connect((value) => {
                chart.config.y_axis.update_bounds(value);
            });
            return serie;
        }

        public new Serie get(int index) throws ChartError {
            if (index > series.size - 1) {
                throw new ChartError.SERIE_NOT_FOUND("Serie at index %d not found".printf(index));
            }
            return series.get(index);
        }

        public Serie get_by_name(string name) throws ChartError {
            foreach (Serie serie in series) {
                if (serie.name == name) return serie;
            }
            throw new ChartError.SERIE_NOT_FOUND("Serie with name %s not found".printf(name));
        }

        public Iterator<Serie> iterator() {
            return series.list_iterator();
        }
    }
    
    [Version (experimental=true)]
    public class TimeSeries {

        private Gee.ArrayList<TimeSerie> series = new Gee.ArrayList<TimeSerie>();
        private Chartable chart;

        public TimeSeries(Chartable chart) {
            this.chart = chart;
        }

        public TimeSerie register(TimeSerie serie) {
            this.series.add(serie);
            //if values were added to serie before registration
            serie.get_values().foreach((value) => {chart.config.y_axis.update_bounds(value.value); return true;});
            
            if(chart.legend != null) chart.legend.add_legend(serie);
            serie.value_added.connect((value) => {
                chart.config.y_axis.update_bounds(value);
            });
            return serie;
        }

        public new TimeSerie get(int index) throws ChartError {
            if (index > series.size - 1) {
                throw new ChartError.SERIE_NOT_FOUND("Serie at index %d not found".printf(index));
            }
            return series.get(index);
        }

        public TimeSerie get_by_name(string name) throws ChartError {
            foreach (TimeSerie serie in series) {
                if (serie.name == name) return serie;
            }
            throw new ChartError.SERIE_NOT_FOUND("Serie with name %s not found".printf(name));
        }

        public Iterator<TimeSerie> iterator() {
            return series.list_iterator();
        }
    }
}