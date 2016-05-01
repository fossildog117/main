import java.util.ArrayList;


class Logger {
    
    class Log {
        private long timestamp;
        private float body;

        Log(float f) {
            this.timestamp = System.currentTimeMillis();
            this.body = f;
        }

        float getBody(){
            return this.body;
        }
    }

    private Serial mySerial;
    private ArrayList<Log> ph;
    private ArrayList<Log> temp;
    private ArrayList<Log> stir;  
    private ArrayList<String> unsliced;
    
    Logger() {
        ph = new ArrayList<Log>();
        temp = new ArrayList<Log>();
        stir = new ArrayList<Log>();
        unsliced = new ArrayList<String>();
    }

    public void newLog(String s, int type){
        if (type == 3)
            this.unsliced.add(s);
    }

    public void newLog(float s, int type) {
        if (type == 0)
            this.temp.add(new Log(s));
        else if (type == 1)
            this.ph.add(new Log(s));
        else if (type == 2)
            this.stir.add(new Log(s));
        return;
    }

    private ArrayList<Float> getItems (int x, ArrayList<Log> list){
        int size = list.size();
        if (x >= size)
                x = size;
        
        ArrayList<Float> arr = new ArrayList<Float>();
        for (int i = 0; i > x; i++){
            int pos = list.size() - 1 - i;
            arr.add(getArrayListItem(pos, list));
        }
        return arr;
    }

    private float getArrayListItem(int i, ArrayList<Log> list) {
        return list.get(i).getBody();
    }

    public float lastPH() {
        return getArrayListItem(ph.size() - 1, ph);
    }

    public float lastTemp() {
        return getArrayListItem(temp.size() - 1, temp);
    }

    public float lastStir() {
        return getArrayListItem(stir.size() - 1, stir);
    }

    public ArrayList<Float> xPH (int x) {
        return getItems(x, ph);
    }

    public ArrayList<Float> xTemp (int x) {
        return getItems(x, temp);
    }

    public ArrayList<Float> xStir (int x) {
        return getItems(x, stir);
    }
}