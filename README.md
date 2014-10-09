Hack Oregon Prototype
================

This application was inspired by my meeting with Sam Higgins and Melissa Lewis at [Hack Oregon](http://www.hackoregon.org/) during their meetup on the 30th of September 2014. They kindly showed me their project and I decided to build a quick Ruby on Rails prototype in an attempt to understand what the Hack Oregon team wanted to build. This project was done over about a week, taking about 2-3 days of work with most of it taking place over the weekend of 4th to 5th of October 2014.

It's unlikely that I'll continue working on this as I'll probably start contributing to the Hack Oregon project, so feel free to build upon this project if you so choose!

Background
-----------
Oregon's [Secretary of State website](http://sos.oregon.gov/Pages/default.aspx) allows you to [search](https://secure.sos.state.or.us/orestar/gotoPublicTransactionSearch.do) for the following data:
- Candidates
- Committees
- Campaign Finance Transactions

The purpose of this application is to download the above data and make it accessible to the public via a user interface and api.

Key Challenges
-----------

The main challenge for an experienced Ruby on Rails engineer will be dealing with the Secretary of State website. I had attempted the following approaches to download the website:

- Curl
- HttpParty gem
- Mechanize gem

I settled on Mechanize as it simulated the behaviour of the website. Key gotchas are:

- It appears to use information set in the Referrer HTTP Request Header for downloading xls spreadsheets
- The Secretary of State website user interface sets hidden http post variables in javascript

Once the XLS spreadsheets are downloaded, I also tried multiple approaches to importing the XLS data into the database:

- Spreadsheet gem
- Roo gem
- gnumeric
- CatDoc (xls2csv)

For some of the XLS files, both the spreadsheet and roo gems would run at 100% ruby cpu usage for more than 10 minutes before I decided to give up on it. Other times it would return an empty array of data. I could not compile gnumeric via MacPorts, so I gave up on that too. I'm using xls2csv from CatDoc, which works well, and I've compiled and committed a binary for deploying to Heroku in /.heroku/

There's a list of rake tasks under the data namespace to help you import data. eg.,
- foreman run rake data:process_candidate_filings_for[2013,2014]
- foreman run rake data:process_committees_for[A,Z]
- foreman run rake data:process_transactions_for[2014-09-01,2014-10-03]

Architecture
-----------

Aside from the gems listed in the Gemfile, key external dependencies are:

- CatDoc (I'm using xls2csv)
- NVD3 in vendor/assets/
- Jquery-UI autocompleter in vendor/assets/

Run "rake erd" to generate an erd diagram

API
-----------

Listing candidates
- /api/candidates.json

Listing campaign finance transactions for a candidate
- /api/candidates/113/campaign_finance_transactions.json

In progress / unfinished
- Api::Analytics::CampaignFinanceTransactionsController

Ruby on Rails
-------------

This application requires:

- Ruby 2.1.2
- Rails 4.1.6


Getting Started
---------------

- Install CatDoc (eg., via macports)
- Install Ruby 2.1.2
- run bundle install
- set .env file with data eg.,
  - ADMIN_NAME=First User
  - ADMIN_EMAIL=user@example.com
  - ADMIN_PASSWORD=changeme
  - S3_BUCKET_NAME=
  - AWS_ACCESS_KEY_ID=
  - AWS_SECRET_ACCESS_KEY=


Demo
----------------

You can see an example on Heroku here: [hack-oregon-prototype.herokuapp.com](hack-oregon-prototype.herokuapp.com). Data has been imported for transactions between 2014-Jun-01 till 2014-Oct-03. Try searching using the autocompleter for a candidate eg., Jennifer Williamson, or click on one of the candidates with top 10 amounts.


Similar Projects
----------------

Inspired by work by [Hack Oregon](https://github.com/hackoregon)

Credits
-------

2014 - Jonathan Chang

License
-------
The MIT License (MIT)

Copyright (c) 2014 Jonathan Chang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
