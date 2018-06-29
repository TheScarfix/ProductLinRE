# README [![Build Status](https://travis-ci.org/TheScarfix/ProductLinRE.svg?branch=master)](https://travis-ci.org/TheScarfix/ProductLinRE)

This readme covers the installation of the Ruby on Rails application ProductLinRE (www.productlinre.com)

## 1. Ruby version and System dependencies
* minimum Ruby 2.3.0, Rails 5.2.0

### Libraries and external executables:
* FFMpeg for video and audio editing
* ImageMagick for image editing (used by MiniMagick gem)
* Java Runtime for Document Text Extraction (used by henkei gem which uses Apache Tika)
* SQLite3 as database engine (for development)
* PostgreSQL or MySQL as database server (for production)
* Apache2 with mod-passenger as web server (tested, other servers like nginx might work too)

### Example package names for Debian/Ubuntu
* ruby-dev
* ffmpeg
* imagemagick
* default-jre
* sqlite3-dev
* postgres-9.6
* apache2-mod-passenger

## 2. Setup and Configuration (for development and testing)
The application uses the gem Bundler for gem management, to install all gems needed to run the application run

    bundle install

inside the application folder. If Bundler isn't installed run

    gem install bundler


To update the gems of the application run
    
    bundle update

The configured gems are listed inside the Gemfile inside the application root folder

For more information about the gems used visit <https://rubygems.org>

    
## 3. Deployment (for staging and production)
Deployment can be done with capistrano. In the /config/deploy folder are the stages where the remote servers are listed.
In the /config/deploy.rb are settings for all stages.
Deployment is done with SSH. To make this work SSH keys are needed.

Before deploying to a server a database.yml and master.key file needs to exist inside the /shared/config/ folder where you want to deploy to.
The database.yml contains database installation information.

For information about database configuration visit <http://guides.rubyonrails.org/configuring.html#configuring-a-database>

The master.key contains the key used to encrypt credentials. It can be set up with

    rails credentials:edit
    

After the servers are configured deployment is started with the

    cap *stagename* deploy
    
This command fetches the latest git commit and installs it to the configured deploy_to folder and migrates the database.

Further information about Capistrano is at <http://capistranorb.com/>

## 4. Database
If you deployed with Capistrano the database should already exist and work.

For development environments you need to configure the database.yml or rename the database.yml.example and run
    
    rails db:setup
    
to set the database up and seed it with values for testing

## 5. Localization
The application uses the standard Ruby on Rails i18n gem to provide Internationalization.
To localize the app to your language you need to create a .yml file inside the config/locale folder.

You should only need to create localization for the keys used inside the en.yml file and devise.en.yml file we provide.

The other keys are localized by other integrated gems like devise-i18n or rails-i18n.

For further information about localization visit <http://guides.rubyonrails.org/i18n.html> 
