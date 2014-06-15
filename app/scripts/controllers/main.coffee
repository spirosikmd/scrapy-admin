'use strict'

class Spider

  constructor: (@name, @running, @jobId) ->

  start: =>
    @running = true

  stop: =>
    @running = false
    @jobId = ''

angular.module('crawlerInterfaceApp')
  .controller 'MainCtrl', ($scope, $http) ->
    $scope.spiders = []
    $scope.finishedJobs = []
    $scope.runningJobs = []

    config = {
      method: 'GET',
      url: 'http://localhost:6800/listjobs.json',
      params: {
        'project': 'default'
      }
    }
    $http(config)
      .success (data, status, headers, config) ->
        $scope.finishedJobs.push(job) for job in data.finished
        $scope.runningJobs.push(job) for job in data.running
        console.log data
      .error (data, status, headers, config) ->
        console.log data

    config = {
      method: 'GET',
      url: 'http://localhost:6800/listspiders.json',
      params: {
        'project': 'default'
      }
    }
    $http(config)
      .success (data, status, headers, config) =>
        $scope.spiders.push(new Spider(spider, isRunning(spider), getJobId(spider))) for spider in data.spiders
      .error (data, status, headers, config) ->
        console.log data

    isRunning = (spider) ->
      for runningJob in $scope.runningJobs
        if runningJob.spider is spider
          return true
      return false

    getJobId = (spider) ->
      for runningJob in $scope.runningJobs
        if runningJob.spider is spider
          return runningJob.id
      return ''

    $scope.startSpider = (spider) ->
      data = {}
      config = {
        headers: {
          'Content-Type': undefined
        },
        params: {
          'project': 'default',
          'spider': spider.name
        }
      }
      $http.post('http://localhost:6800/schedule.json', data, config)
        .success (data, status, headers, config) ->
          spider.start()
          spider.jobId = data.jobid
          console.log data
        .error (data, status, headers, config) ->
          console.log data

    $scope.cancelSpider = (spider) ->
      data = {}
      config = {
        headers: {
          'Content-Type': undefined
        },
        params: {
          'project': 'default',
          'job': spider.jobId
        }
      }
      $http.post('http://localhost:6800/cancel.json', data, config)
        .success (data, status, headers, config) ->
          spider.stop()
          console.log data
        .error (data, status, headers, config) ->
          console.log data
