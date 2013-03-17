fs = require 'fs'

NPMVendorize = require './lib/index'
expect = require('chai').expect

describe 'preprocessor', ->

  # make the preprocessor var available
  preprocessor = null

  beforeEach ->
    t = __dirname + '/fixtures'
    #t = './fixtures'
    vendor = { }
    vendor[t] = { include: 'foo.js' }
    preprocessor = new NPMVendorize
      paths:
        app: ''
      plugins:
        vendorize: vendor

  it 'should instantiate', ->
    expect(preprocessor).to.be.ok
    expect(preprocessor).to.be.an.instanceof NPMVendorize

  it 'should have an include method', ->
    expect(preprocessor['include']).to.be.an.instanceof Function

  it 'include method should return sources list', ->
    answer = require.resolve('./fixtures/foo.js')
    expect(preprocessor.include( )[0]).to.equal(answer)
