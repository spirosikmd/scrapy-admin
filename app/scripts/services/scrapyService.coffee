'use strict'

angular.module('crawlerInterfaceApp')
  .factory 'ScrapyService', ($http) ->
    data = {}
    config = {
      headers: {
        'Content-Type': undefined
      },
      params: {
        'project': 'default'
      }
    }

    {
      getJobs: () ->
        $http.get('http://localhost:6800/listjobs.json', config)
          .then (result) ->
            result.data

      getSpiders: () ->
        $http.get('http://localhost:6800/listspiders.json', config)
          .then (result) ->
            result.data

      startSpider: (spiderName) ->
        config.params.spider = spiderName
        return $http.post('http://localhost:6800/schedule.json', data, config)
          .then (result) ->
            result.data

      cancelSpider: (jobId) ->
        config.params.job = jobId
        return $http.post('http://localhost:6800/cancel.json', data, config)
          .then (result) ->
            result.data
    }
