# -*- coding: utf-8 -*-
import scrapy
from time import sleep
from scrapy import Spider
from selenium import webdriver
from scrapy.http import Request
from scrapy.selector import Selector

 
class StockIndexSpider(scrapy.Spider):
    name = 'stock_index'
    allowed_domains = ['www.thestar.com.my/business/marketwatch/']
    start_urls = ('http://www.thestar.com.my/business/marketwatch/',)

    def parse(self, response):
        self.driver = webdriver.Chrome('/Users/Leonard Teng/Desktop/WQD 7005/Assignment/Assignment 1/Klse_spider/chromedriver.exe')
        self.driver.get('http://www.thestar.com.my/business/marketwatch/')
        sleep(5)
        sel = Selector(text=self.driver.page_source) 
        for row in sel.xpath('//*[@id="tblmarketmovers"]/tbody//tr'):
         yield {
                'Symbol' : row.xpath('td[1]//text()').extract_first(),
                'Open': row.xpath('td[2]//text()').extract_first(),
                'High' : row.xpath('td[3]//text()').extract_first(),
                'Low' : row.xpath('td[4]//text()').extract_first(),
                'Last': row.xpath('td[5]//text()').extract_first(),
                'Chg' : row.xpath('td[6]//text()').extract_first(),
                '%Chg' : row.xpath('td[7]//text()').extract_first(),
                'Vol("00)': row.xpath('td[8]//text()').extract_first()
            }

