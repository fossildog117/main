package com.company;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.LinkedList;
import java.util.Queue;

public class Crawler {

    private LinkedList<String> queue;
    private float lowestPrice = 100000;

    Crawler() {
        this.queue = new LinkedList<>();
    }

    public int getLinks(int j) {

        try {

            for (int i = j; i < 5; i++) {

                Document doc = Jsoup.connect("http://www.amazon.co.uk/s/ref=sr_pg_2?rh=i%3Aaps%2Ck%3Aelectric+scooter&page=" + i + "&sort=price-desc-rank&keywords=electric+scooter&ie=UTF8&qid=1459950877").get();
                Element content = doc.getElementById("s-results-list-atf");
                org.jsoup.select.Elements links = content.getElementsByTag("a");

                for (Element e : links) {

                    if (e.className().equals("a-link-normal a-text-normal")) {
                        queue.add(e.attr("href"));
                    }
                }
            }
        } catch (Exception e) {
            return getLinks(j + 1);
        }

        return 1;

    }

    public boolean crawl() {

        // breadth first search a-link-normal a-text-normal priceblock_ourprice

        while (queue.size() > 0) {
            try {

                Document doc = Jsoup.connect(queue.get(0)).get();

                Element title = doc.getElementById("title");
                System.out.println(title.text());

                Element price = doc.getElementById("priceblock_ourprice");
                String stringPrice = price.text().replace("£", "");
                System.out.println(price.text());

                Element description = doc.getElementById("productDescription");
                System.out.println(description.text() + "\n\n");

                if (Float.valueOf(stringPrice) < lowestPrice) {
                    lowestPrice = Float.valueOf(stringPrice);
                }

                queue.remove(0);

            } catch (Exception e) {
                queue.remove(0);
                return crawl();
            }
        }

        System.out.println(lowestPrice);

        System.out.println("Finished");

        return true;

    }

}
