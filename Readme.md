# Tailor

## Install

Install app

    $ git clone REPO
    $ cd REPO
    $ npm install
    
You may also need to install coffee script

    $ npm install -g coffee-script

## Usage

Start the server, optionally passing a port for the server to run on and specifying any number of files to watch.

    $ coffee server.coffee -p 3003 /var/log/apache2/access_log /var/log/apache2/server_log
    
Open browser and view logs as they change.

    $ open http://localhost:3003