# -*- coding: utf-8 -*-
import scrapy
from time import sleep
from scrapy import Spider
from selenium import webdriver
from scrapy.http import Request
from scrapy.selector import Selector


class KlseSpider(scrapy.Spider):
    name = 'KLSE'
 
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
        name = response.xpath('//h1[@class="stock-profile f16"]/text()').extract()
        stock_code = response.xpath('//*[@id="slcontent_0_ileft_0_info"]/ul/div[1]/li[2]/text()').extract()[0][3:]
        price = response.xpath('//td[@id="slcontent_0_ileft_0_lastdonetext"]/text()').extract()
        board = response.xpath('//*[@id="slcontent_0_ileft_0_info"]/ul/div[1]/li[1]/text()').extract()[0][3:7]
        volume = response.xpath('//td[@id="slcontent_0_ileft_0_voltext"]/text()').extract()
        buy_volume = response.xpath('//*[@id="slcontent_0_ileft_0_buyvol"]/text()').extract()
        sell_volume = response.xpath('//*[@id="slcontent_0_ileft_0_sellvol"]/text()').extract()
        date = response.xpath('//span[@id="slcontent_0_ileft_0_datetxt"]/text()').extract()[0][10:-2]
        time = response.xpath('//span[@id="slcontent_0_ileft_0_timetxt"]/text()').extract()
        P_end_1 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[1]/td[4]/text()').extract()
        revenue_1 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[1]/td[5]/text()').extract()
        PL_1 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[1]/td[6]/text()').extract()
        EPS_1 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[1]/td[7]/text()').extract()
        P_end_2 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[2]/td[4]/text()').extract()
        revenue_2 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[2]/td[5]/text()').extract()
        PL_2 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[2]/td[6]/text()').extract()
        EPS_2 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[2]/td[7]/text()').extract()
        P_end_3 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[3]/td[4]/text()').extract()
        revenue_3 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[3]/td[5]/text()').extract()
        PL_3 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[3]/td[6]/text()').extract()
        EPS_3 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[3]/td[7]/text()').extract()
        P_end_4 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[4]/td[4]/text()').extract()
        revenue_4 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[4]/td[5]/text()').extract()
        PL_4 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[4]/td[6]/text()').extract()
        EPS_4 = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr[4]/td[7]/text()').extract()
        Fin_date = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financetableheaad"]/tr/td[4]/span/text()').extract()
        Net_sales = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[2]/td[4]/text()').extract()
        Ebitda = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[3]/td[4]/text()').extract()
        Ebit = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[4]/td[4]/text()').extract()
        Net_Profit = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[5]/td[4]/text()').extract()
        Intangible = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[7]/td[4]/text()').extract()
        Fixed_Asst = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[8]/td[4]/text()').extract()
        Long_Inv = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[9]/td[4]/text()').extract()
        Invent = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[10]/td[4]/text()').extract()
        Cash = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[11]/td[4]/text()').extract()
        Cur_Lia = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[12]/td[4]/text()').extract()
        Long_debt = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[13]/td[4]/text()').extract()
        Provis = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[14]/td[4]/text()').extract()
        Minor = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[15]/td[4]/text()').extract()
        Share_Equi = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[16]/td[4]/text()').extract()
        Op_Margin = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[18]/td[4]/text()').extract()
        Roc = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[19]/td[4]/text()').extract()
        Npm = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[20]/td[4]/text()').extract()
        Cur_ratio = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[21]/td[4]/text()').extract()
        D_C_ratio = response.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_fundamentals_financialtable"]/tr[22]/td[4]/text()').extract()


        yield{
        'stock name':name,
        'price':price,
        'board':board,
        'volume':volume,
        'buy_volume': buy_volume,
        'sell_volume': sell_volume,
        'date':date,
        'time':time,
        'Period End 1':P_end_1,
        'Revenue 1':revenue_1,
        'P&L 1':PL_1,
        'EPS 1':EPS_1,
        'Period End 2':P_end_2,
        'Revenue 2':revenue_2,
        'P&L 2':PL_2,
        'EPS 2':EPS_2,
        'Period End 3':P_end_3,
        'Revenue 3':revenue_3,
        'P&L 3':PL_3,
        'EPS 3':EPS_3,
        'Period End 4':P_end_4,
        'Revenue 4':revenue_4,
        'P&L 4':PL_4,
        'EPS 4':EPS_4,
        'Financial Date':Fin_date,
        'Sales':Net_sales,
        'Ebitda':Ebitda,
        'Ebit':Ebit,
        'Net Profit':Net_Profit,
        'Intangibles':Intangible,
        'Fixed Asset':Fixed_Asst,
        'Long Term Investment':Long_Inv,
        'Inventories':Invent,
        'Cash':Cash,
        'Current Liabilites':Cur_Lia,
        'Long_debt':Long_debt,
        'Provisions':Provis,
        'Minorities':Minor,
        'Total Shareholder Equity':Share_Equi,
        'Operating Margin':Op_Margin,
        'Return on Equity Capital':Roc,
        'Net Profit Margin':Npm,
        'Current Ratio':Cur_ratio,
        'Debt to Capital at book':D_C_ratio,
        }




