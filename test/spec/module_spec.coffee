Module = require './lib/module'
Preprocessor = require './lib/preprocessor'
expect = require('chai').expect
extend = require 'node.extend'

ExistingModulesFixtures = require './fixtures/modules/existing'
UnknownModulesFixtures = require './fixtures/modules/unknown'

describe 'module', ->

  settings = extend(yes, {
    paths:
      app: ''
  }, Preprocessor::defaults)

  for moduleFixture in ExistingModulesFixtures
    do (moduleFixture) ->
      module = new Module
        isVendor: moduleFixture.isVendor
        location: moduleFixture.location
      , settings, settings.paths.app

      it 'should be instantied', ->
        expect(module).to.be.an.instanceof Module

      it 'should find the file path of ' + moduleFixture.location, ->
        expect(module.findPath()).to.be.true

        it 'should find the correct file path', ->
          expect(module.path).to.equal 'controllers/base-controller'

      it 'should generate the correct var name', ->
        expect(module.getVarName()).to.equal moduleFixture.varName

  for moduleFixture in UnknownModulesFixtures
    do (moduleFixture) ->
      module = new Module
        isVendor: moduleFixture.isVendor
        location: moduleFixture.location
      , settings, settings.paths.app

      it 'should be instantied', ->
        expect(module).to.be.an.instanceof Module

      it 'should not find the file path of ' + moduleFixture.location, ->
        expect(module.findPath()).to.be.false
