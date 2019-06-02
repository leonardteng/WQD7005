# -*- coding: utf-8 -*-
import scrapy
from time import sleep
from scrapy import Spider
from selenium import webdriver
from scrapy.http import Request
from scrapy.selector import Selector


class StockNewsSpider(scrapy.Spider):
	name = 'Stock_News_Manual'
	
	def start_requests(self):
			ticker = 'https://klse.i3investor.com/servlets/stk/nb/5218.jsp'
			stock_code = '5218'
			yield Request(ticker,
					  callback=self.parse_i3,
								 meta=
										{'stock code':stock_code})
  
	def parse_i3(self, response):
	   
		dup_links = response.xpath('//td[@class="left"]/a/@href').extract()
		seen = set()
		i3_links = [x for x in dup_links if x not in seen and not seen.add(x)]  # remove duplicate news link
		stock_name = response.xpath('//*[@class="stcompany"]/text()').extract()
		stock_code = response.meta['stock code']
		# comments = response.xpath('//*[@class="autolink"]/text()').extract()
		# comments = ' '.join(comments)
		# response.meta['stock_name'] = stock_name
		# yield response.meta
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
