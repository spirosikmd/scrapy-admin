scrapy-admin
============

An admin interface built with [AngularJS](https://angularjs.org/) to control [Scrapy](http://scrapy.org/) spiders, check
their live stats, and get an overview of jobs. The [EventSource](https://developer.mozilla.org/en-US/docs/Web/API/EventSource),
[pushserver](https://github.com/paylogic/pushserver), and [redis](http://redis.io/) projects are used to publish data in
an asynchronous manner.

## Getting started

Follow the instrunctions from [pushserver](https://github.com/paylogic/pushserver) and start your push server with
`python manage.py runserver`. This will start push server on `http://localhost:8080/`. This url is used when
[initializing](https://github.com/spirosikmd/scrapy-admin/blob/master/app/scripts/controllers/main.coffee) the EventSource.

Redis is also required to run. Install redis and run `redis-server`.

After you have also successfully installed [scrapyd](http://scrapyd.readthedocs.org/en/latest/), run `scrapyd`, which
will start the scrapy process listening on `http://localhost:6800`. This url is used in the
[scrapyService](https://github.com/spirosikmd/scrapy-admin/blob/master/app/scripts/services/scrapyService.coffee) to get
the data from Scrapy.

Finally run `grunt server` from scrapy-admin root directory to start the AngularJS project.
