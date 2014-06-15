'use strict'

describe 'Service: Scrapyservice', () ->

  # load the service's module
  beforeEach module 'CrawlerinterfaceApp'

  # instantiate service
  Scrapyservice = {}
  beforeEach inject (_Scrapyservice_) ->
    Scrapyservice = _Scrapyservice_

  it 'should do something', () ->
    expect(!!Scrapyservice).toBe true
