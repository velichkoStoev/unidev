#UniDev

[![Build Status](https://travis-ci.org/velichkoStoev/unidev.svg?branch=master)](https://travis-ci.org/velichkoStoev/unidev)  

##Setup 
###Requirements
- Ruby 2.2.1
- Rails 4.2.4
- PosgreSQL 9.3.9
- ImageMagick

I have installed Ruby and Rails using [RVM](https://rvm.io/) and I use [PgAdmin3](http://www.pgadmin.org/) for  a database management.  
[Paperclip gem requires ImageMagick](https://github.com/thoughtbot/paperclip#image-processor).

###Steps 
1. Clone this repo into a folder of choice with ```git clone```.
2. Execute ```bundle install``` in order to install the gem dependencies.
3. Create PSQL user called ```unidev``` with password ```unidev``` and execute ```rake db:setup```. 
4. Start your Rails server with ```rails s``` or ```rails server```.



