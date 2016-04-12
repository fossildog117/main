package com.company;

public class Main {

    public static void main(String[] args) {

        Crawler crawler = new Crawler();
        crawler.getLinks(1);
        crawler.crawl();

    }
}
