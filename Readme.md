# Tailor

Watch your log files through a web UI.

<img src="http://alexandergibbons.com/static/tailor_screen_shot.png" title="Screen Shot" width="800"/>

## Install

Install app

    $ git clone REPO
    $ cd REPO
    $ npm install
    
You may also need to install coffee script

    $ npm install -g coffee-script

## Usage

Basic usage

    $ coffee server.coffee /var/log/*.log

See help for more options, including enabling http basic auth.

    $ coffee server.coffee --help
    
Open browser and view logs as they change.

    $ open http://localhost:3003