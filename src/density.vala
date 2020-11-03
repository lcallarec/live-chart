namespace LiveChart { 
    
    public enum Density {
        AUTO,
        LOW,
        MEDIUM,
        HIGH;

        public bool is_within(float value) {
            switch(this) {
                case LOW:
                    return value >= 2f && value <= 4f;
                case MEDIUM:
                    return value >= 4f && value <= 8f || value >= 2f && value <= 4f;
                case HIGH:
                    return value >= 5f && value <= 10f || value >= 4f && value <= 8f || value >= 2f && value <= 4f;
                default:
                    return value >= 4f && value <= 6f;
            }
        }
    }
}
