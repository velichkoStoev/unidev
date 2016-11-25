#UniDev

[![Build Status](https://travis-ci.org/velichkoStoev/unidev.svg?branch=master)](https://travis-ci.org/velichkoStoev/unidev)  

##Setup 
###Requirements
- Ruby 2.2.1
- Rails 4.2.4
- PosgreSQL 9.3.9

I have installed Ruby and Rails using [RVM](https://rvm.io/) and I use [PgAdmin3](http://www.pgadmin.org/) for  a database management. 

###Steps 
1. Clone this repo into a folder of choice with ```git clone```.
2. Install required gem dependencies: 
  - [ImageMagick](https://github.com/thoughtbot/paperclip#image-processor) (used by paperclip)
  - [Qt and Xvfb](https://github.com/velichkoStoev/unidev/wiki/Setup-capybara-webkit) (used by capybara-webkit)
3. Execute ```bundle install``` in order to install the gem dependencies.
4. Create PSQL user called ```unidev``` with password ```unidev``` and execute ```rake db:setup```. 
5. Start your Rails server with ```rails s``` or ```rails server```.
6. Run the specs with ```bundle exec rspec``` or with ```COVERAGE=true bundle exec rspec``` if you want a coverage report. 

##Wiki
Please visit our [wiki page](https://github.com/velichkoStoev/unidev/wiki) for more information. 
