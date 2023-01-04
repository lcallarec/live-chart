using Gee;
namespace LiveChart { 

    public class Series : Object {
        private Gee.Map<Serie, ulong> signals = new Gee.HashMap<Serie, ulong>();
        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();
        private weak Chart chart;

        public Series(Chart chart) {
            this.chart = chart;
        }

        public Serie register(Serie serie) {
            if(series.contains(serie)){
                return serie;
            }
            this.series.add(serie);
            //if values were added to serie before registration
            serie.get_values().foreach((value) => {chart.config.y_axis.update_bounds(value.value); return true;});
            
            if(chart.legend != null) chart.legend.add_legend(serie);
            var sh = serie.value_added.connect((value) => {
                chart.config.y_axis.update_bounds(value);
            });
            signals[serie] = sh;
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
        
        public void remove_serie(Serie serie){
            if(signals.has_key(serie)){
                var sh = signals[serie];
                serie.disconnect(sh);
                signals.unset(serie);
            }
            if(series.contains(serie)){
                series.remove(serie);
            }
            if(chart.legend != null){
                chart.legend.remove_legend(serie);
            }
        }
        
        public void remove_all(){
            foreach(var entry in signals){
                entry.key.disconnect(entry.value);
            }
            signals.clear();
            series.clear();
            if(chart.legend != null){
                chart.legend.remove_all_legend();
            }
        }
        
        public Iterator<Serie> iterator() {
            return series.list_iterator();
        }
    }
}