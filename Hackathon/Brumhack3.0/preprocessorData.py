#!/usr/bin/env python

import boto3
from boto3.dynamodb.conditions import Key



class Company():
	def __init__(self, name, stockcode):
		self.stockcode = stockcode
		self.name = name
		self.years = []

	def addYear(self, year):
		self.years.append(year)

	def __str__(self):
		return self.name

	def hasYear(self, year):
		for y in self.years:
			if y.name == year:
				return True
		return False

	def getYear(self, year):
		for y in self.years:
			if y.name == year:
				return y 

class Year():
	def __init__(self, year):
		self.name = year
		self.months = []

	def addMonth(self, month):
		self.months.append(month)

	def hasMonth(self, month):
		for m in self.months:
			if m.name == month:
				return True
		return False

	def getMonth(self, month):
		for m in self.months:
			if m.name == month:
				return m

class Month():
	def __init__(self, name):
		self.name = name
		self.value = 0.0
		self.nrDays = 1

	def addDay(self, value):
		self.nrDays = self.nrDays + 1
		self.value = self.value + value

	def computeOverallValue(self):
		self.value = self.value / float(self.nrDays)




def connect():
	AWS_REGION = 'us-east-1'
	db = boto3.resource('dynamodb', region_name = AWS_REGION)	
	return db


def grabData(company, startDate, endDate, year, db):
	table = db.Table(str(year))
	startDate = str(year) + '-' + startDate 
	endDate = str(year) + '-' + endDate
	data = table.query(KeyConditionExpression = Key('Ticker').eq(company.stockcode) & Key('Date').between(startDate, endDate))
	return data['Items']

def extractMonth(data, company):
	for d in data:
		year = d['Date'][0:4]
		month = d['Date'][5:7]
		value = float(d['Market_Cap'])  
		if not company.hasYear(year):
			company.addYear(Year(year))
		if not company.getYear(year).hasMonth(month):
			company.getYear(year).addMonth(Month(month))
		company.getYear(year).getMonth(month).addDay(value)

def pullYears(company, startYear, endYear, db):
	if endYear < startYear:
		tmp = endYear
		endYear = startYear
		startYear = endYear
	print(company.name)
	for year in range(startYear, endYear+1):
		extractMonth(grabData(company, '01-01', '12-31', year, db), company)
		print(str(year) + " done")

if __name__ == "__main__":
	startYear = 2006
	endYear = 2013
	ibm = Company('IBM','IBM US Equity')
	apple = Company('APPLE','AAPL US Equity')
	yhoo = Company('YAHOO','YHOO US Equity')
	ko = Company('COCA-COLA','KO US Equity')
	bmw = Company('BMW','BMW GR Equity')
	gs = Company('GOLDMAN SACHS','GS US Equity')
	arr = [ibm, apple, yhoo, ko, bmw, gs]
	db = connect()
	for i in range(0, len(arr)):
		pullYears(arr[i], startYear, endYear, db)

	#write file
	fh = open("bloomberg.brumhack", "w")
	for company in arr:
		for y in company.years:
			for m in y.months:
				m.computeOverallValue()
				fh.write(str(company.name) +","+ str(m.name) + "," + str(y.name) + "," + str(int(m.value)) + "\n")
	fh.close()

	