# -*- coding: utf-8 -*-
import scrapy
from time import sleep
from scrapy import Spider
from selenium import webdriver
from scrapy.http import Request
from scrapy.selector import Selector


class StockNewsSpider(scrapy.Spider):
	name = 'Stock_News'
	
	def start_requests(self):
		self.driver = webdriver.Chrome('/Users/Leonard Teng/Desktop/WQD 7005/Assignment/Assignment 1/Klse_spider/chromedriver.exe')
 
		alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
		for alpha in alphabets:
			self.driver.get('https://www.thestar.com.my/business/marketwatch/stock-list/?alphabet=' + alpha)
			sleep(5)
 
			sel = Selector(text=self.driver.page_source)
			tickers = sel.xpath('//tr[@class="linedlist"]/td/a/@href').extract()
			for ticker in tickers:
				ticker = 'https://www.thestar.com.my' + ticker
				yield Request(ticker,
							  callback=self.parse)


	def parse(self, response):
		stock_code = response.xpath('//*[@id="slcontent_0_ileft_0_info"]/ul/div[1]/li[2]/text()').extract()[0][3:]
		i3_url = 'https://klse.i3investor.com/servlets/stk/'+str(stock_code)+'.jsp'
		sleep(1)
		yield Request(i3_url,
					  callback=self.parse_i3,
								 meta=
										{'stock code':stock_code})
  
	def parse_i3(self, response):
	   
		dup_links = response.xpath('//td[@class="left"]/a/@href').extract()
		seen = set()
		i3_links = [x for x in dup_links if x not in seen and not seen.add(x)]  # remove duplicate news link
		stock_name = response.xpath('//*[@class="stcompany"]/text()').extract()
		stock_code = response.meta['stock code']
		for link in i3_links:
			link = 'https://klse.i3investor.com' + link
			sleep(1)
			yield Request(link, callback=self.parse_headlines, 
				meta = {'stock name':stock_name, 'stock code':stock_code})


	def parse_headlines(self, response):
		date = response.xpath('//time[@itemprop="datePublished"]/text()').extract()
		title = response.xpath('//h2[@itemprop="headline"]/text()').extract()
		subhead = response.xpath('//*[@class="margint30"]//h3/text()').extract()
		para = response.xpath('//*[@class="margint30"]//p/text()').extract()
		subhead = ' '.join(subhead)
		para = ' '.join(para)
		stock_name = response.meta ['stock name']
		stock_code = response.meta ['stock code']
		yield {'stock code':stock_code, 'stock name':stock_name, 'date':date, 'title':title, 'subhead':subhead, 'para':para}
