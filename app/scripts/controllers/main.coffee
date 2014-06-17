'use strict'

class Spider

  constructor: (@name, @running, @jobId, @scrapyService, @scope) ->
    @stats = {}
    @showStats = false

  start: =>
    @scrapyService.startSpider(@name).then (data) =>
      @jobId = data.jobid
      @running = true

  cancel: =>
    @scrapyService.cancelSpider(@jobId).then (data) =>
      @running = false
      @jobId = ''

  updateStats: (stats) =>
    @scope.$apply () =>
      @stats = stats

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
        spider = new Spider(spiderName, isRunning(spiderName), getJobId(spiderName), ScrapyService, $scope)
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

    getSpider = (spiderName) ->
      for spider in $scope.spiders
        if spider.name is spiderName
          return spider
      return undefined

    $scope.startSpider = (spider) ->
      spider.start()

    $scope.cancelSpider = (spider) ->
      spider.cancel()

    spiderOpened = (msg) ->
      console.log "Spider opened"
      console.log JSON.parse(msg.data)

    spiderClosed = (msg) ->
      console.log "Spider closed"
      console.log JSON.parse(msg.data)

    statsCollected = (msg) ->
      data = JSON.parse(msg.data)
      spider = getSpider(data.spider)
      spider.updateStats(data.stats)

    source = new EventSource('http://127.0.0.1:8080/stream?channel=crawler')
    source.addEventListener('spider_opened', spiderOpened, false)
    source.addEventListener('spider_closed', spiderClosed, false)
    source.addEventListener('stats_collected', statsCollected, false)
