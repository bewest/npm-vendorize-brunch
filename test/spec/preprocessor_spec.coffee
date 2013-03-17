fs = require 'fs'

Preprocessor = require './lib/preprocessor'
expect = require('chai').expect

describe 'preprocessor', ->

  # make the preprocessor var available
  preprocessor = null

  beforeEach ->
    t = __dirname + '/fixtures'
    #t = './fixtures'
    vendor = { }
    vendor[t] = { include: 'foo.js' }
    preprocessor = new Preprocessor
      paths:
        app: ''
      plugins:
        vendorize: vendor

  it 'should instantiate', ->
    expect(preprocessor).to.be.ok
    expect(preprocessor).to.be.an.instanceof Preprocessor

  it 'should have an include function', ->
    expect(preprocessor['include']).to.be.an.instanceof Function

  it 'include method should return sources list', ->
    answer = require.resolve('./fixtures/foo.js')
    expect(preprocessor.include( )[0]).to.equal(answer)
