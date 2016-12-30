import QB.quantumbiology.HtmlClustering;

import java.io.File;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DeathToEikon {

    // Factors affecting
    // Retention Strength Bias
    // Number of Webpages crawled
    // Threshold Value (minimum retention strength required for final output)

    public static void main(String[] args) {

        Logger logger = Logger.getLogger ("");
        logger.setLevel (Level.OFF);

        retrieveSubjects(System.getProperty("user.dir") + "/out2.txt");
        String starting_url = "http://www.bing.com/search?q=" + "furniture";

        SearchEngine searchEngine;
        int num = 0; // number of webpages crawled

        try {

            Scanner input = new Scanner(System.in);
            num = input.nextInt();
            int retentionStrength = input.nextInt(); // initial retention strength bias
            Assistant.retentionStrengthBias = retentionStrength;
            searchEngine = new SearchEngine(starting_url, num);
            searchEngine.Learn();

            Assistant.PrintList(Assistant.retentionStrengthBias, searchEngine);

        } catch (Exception e) {
            e.printStackTrace();
        }
        //refineList();
    }

    private static void refineList() {

        try {

            PrintWriter writer = new PrintWriter(System.getProperty("user.dir") + "/out1.txt");

            for (Subject subject : Assistant.getSubjectList()) {
                writer.println(subject.getSubjectName().toUpperCase() + "," + subject.getTimeSinceLastRecall() + "," + 1000);
            }

            writer.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static void retrieveSubjects(String filePath) {

        File textFile = new File(filePath);

        try {

            Scanner input = new Scanner(textFile);

            String line;

            while (input.hasNextLine()) {

                line = input.nextLine();
                Assistant.getSubjectList().add(new Subject(
                        Assistant.getFirst(line),
                        Integer.parseInt(Assistant.getMid(line)),
                        Integer.parseInt(Assistant.getEnd(line))
                ));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}