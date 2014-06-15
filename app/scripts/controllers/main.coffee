'use strict'

class Spider

  constructor: (@name, @running, @jobId, @scrapyService) ->

  start: =>
    @scrapyService.startSpider(@name).then (data) =>
      @jobId = data.jobid
    @running = true

  cancel: =>
    @scrapyService.cancelSpider(@jobId)
    @running = false
    @jobId = ''

angular.module('crawlerInterfaceApp')
  .controller 'MainCtrl', ($scope, ScrapyService) ->
    $scope.spiders = []
    $scope.finishedJobs = []
    $scope.runningJobs = []

    ScrapyService.getJobs().then (data) ->
      $scope.finishedJobs.push(job) for job in data.finished
      $scope.runningJobs.push(job) for job in data.running

    ScrapyService.getSpiders().then (data) ->
      for spiderName in data.spiders
        spider = new Spider(spiderName, isRunning(spiderName), getJobId(spiderName), ScrapyService)
        $scope.spiders.push(spider)

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
      spider.start()

    $scope.cancelSpider = (spider) ->
      spider.cancel()
