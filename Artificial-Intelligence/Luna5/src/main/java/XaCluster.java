import QB.quantumbiology.HtmlClustering;
import com.google.common.collect.MapDifference;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;

import java.util.ArrayList;
import java.util.Collections;

/**
 * Created by nathanliu on 26/07/2016.
 */
public class XaCluster {

    private List<Element> ValidClusters = new ArrayList<>();
    private static final double Threshold = 0.6;

    void CreateClusters(String url) {

        try {

            List<Element> ClusterSet = HtmlClustering.getClusterFromUrl(url);
            System.out.println("Validating cluster...");
            ValidateCluster(ClusterSet);
            System.out.println("updating list...");
            UpdateList();

        } catch (Exception e) {
            //e.printStackTrace();
        }

    }

    private void ValidateCluster(List<Element> ClusterSet) {

        for (int i = 0 ; i < ClusterSet.size(); i++) {

            double trueVals = 0;

            List<Element> tags = ClusterSet.get(i).getElementsByAttribute("href");

            for (Element e : tags) {

                if (Assistant.CompareSubject(e.text().toUpperCase())) {

                    trueVals++;
                    double testVal = trueVals/tags.size();

                    if (testVal >= Threshold) {

                        ValidClusters.add(ClusterSet.get(i));
                        ClusterSet = RemoveChildren(ClusterSet, ClusterSet.get(i));
                        break;

                    }

                }

            }

        }

    }

    private List<Element> RemoveChildren(List<Element> clusterSet, Element elem) {

        List<Element> removeChildren = HtmlClustering.getClusterFromElement(elem);

        for (Element child : removeChildren) {
            if (clusterSet.contains(child)) {
                clusterSet.remove(child);
            }
        }

        return clusterSet;

    }

    private void PrintCluster(List<Element> list) {

        for (Element a : list) {

            for (Element link : a.getElementsByAttribute("href")) {

                System.out.println(link.text());

            }

        }

    }

    void UpdateList() {

        System.out.println("Updating subjects");
        for (Subject s : Assistant.getSubjectList()) {

            if (s.getNumberOfMatches() > 0) {
                s.incrementRetentionStrength();
                s.resetLastRecall();

            } else {
                s.incrementLastRecall();
            }

            s.resetNumberOfMatches();

        }

        for (Element e : ValidClusters) {

            for (Element link : e.getElementsByAttribute("href")) {

                int index = Collections.binarySearch(Assistant.getSubjectList(), new Subject(link.text().toUpperCase(), 1, 1), Assistant.s);
                if (index < 0) {
                    // If not already seen add into list
                    Assistant.getSubjectList().add(new Subject(link.text().toUpperCase(), 1, 1));

                } else {
                    // Otherwise we have seen the subject before
                    // treat as positive
                    Assistant.getSubjectList().get(index).resetLastRecall();
                    Assistant.getSubjectList().get(index).incrementRetentionStrength(1);

                }
            }
        }

        Collections.sort(Assistant.getSubjectList(), (o1, o2) -> o1.getSubjectName().compareTo(o2.getSubjectName()));

    }

}
