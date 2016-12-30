import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

/**
 * Created by nathanliu on 17/09/2016.
 */
public class SearchEngine {

    private ArrayList<String> visitedSites;
    private LinkedList<String> queue;
    private int Stopper = 7200000;

    public SearchEngine(String init_url, int stopper) throws IOException {

        this.visitedSites = new ArrayList<>();
        this.queue = new LinkedList<>();
        this.Stopper = stopper;

        Document doc = Jsoup.connect(init_url).get();
        AddAll(doc.getElementsByAttribute("href"));

    }

    public void Learn() {

        int counter = 0;

        DecimalFormat df = new DecimalFormat();
        df.setMaximumFractionDigits(4);

        while (queue.size() >= 0 && ++counter < Stopper) {

            double percentageCompletion = (double) counter/ (double) Stopper;

            System.out.println(df.format(percentageCompletion * 100) + "% complete");
            System.out.println(counter + " pages visited...");

            try {
                Iterate(queue.getFirst());
            } catch (Exception e) {
              //  e.printStackTrace();
            } finally {
                visitedSites.add(queue.remove(0));
            }

        }

    }

    private void Iterate(String visiting_url) throws IOException {

        if (!hasVisited(visitedSites, visiting_url)) {

            Document doc = Jsoup.connect(visiting_url).get();
            AddAll(doc.getElementsByAttribute("href"));

            XaCluster cluster = new XaCluster();
            cluster.CreateClusters(visiting_url);

        }

    }

    private boolean hasVisited(List<String> list1, String url) {

        for (String item1 : list1) {

            if (item1.equals(url)) {
                return true;
            }

        }

        return false;

    }

    private void AddAll(List<Element> list) {

        for (Element s : list) {

            queue.add(s.attr("href"));

        }

    }

    public int getStopper() {
        return Stopper;
    }
}
