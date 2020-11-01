using Gee;
namespace LiveChart { 

    public class Series : Object {

        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();

        public void register(Serie serie) {
            this.series.add(serie);
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
}