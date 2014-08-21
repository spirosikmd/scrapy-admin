scrapy-admin
============

An admin interface built with [AngularJS](https://angularjs.org/) to control [Scrapy](http://scrapy.org/) spiders, check
their live stats, and get an overview of jobs. The [EventSource](https://developer.mozilla.org/en-US/docs/Web/API/EventSource)
of [HTML5 Server-Sent Events](http://www.html5rocks.com/en/tutorials/eventsource/basics/) is used to stream updates.

## Getting started

The project is just an interface. It depends on the [pushserver](https://github.com/paylogic/pushserver) project which
uses [flask-sse](https://github.com/DazWorrall/flask-sse/) to stream updates.

Follow the instrunctions from [pushserver](https://github.com/paylogic/pushserver) and start your push server with
`python manage.py runserver`. This will start push server on `http://localhost:8080/`. This url is used when
[initializing](https://github.com/spirosikmd/scrapy-admin/blob/master/app/scripts/controllers/main.coffee) the EventSource.

Redis is also required to run. Install redis and run `redis-server`.

After you have successfully installed [scrapyd](http://scrapyd.readthedocs.org/en/latest/), run `scrapyd`, which will
start the scrapy process listening on `http://localhost:6800`. This url is used in the
[scrapyService](https://github.com/spirosikmd/scrapy-admin/blob/master/app/scripts/services/scrapyService.coffee) to get
the data from Scrapy.

Finally run `grunt server` from scrapy-admin root directory to start the AngularJS project.

The whole project of course requires a working Scrapy projec which uses in some way [flask-sse](https://github.com/DazWorrall/flask-sse/)
to send events. The configuration is done by the push server.
