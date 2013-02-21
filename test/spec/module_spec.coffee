Module = require './module'
Preprocessor = require './preprocessor'
expect = require('chai').expect
extend = require 'node.extend'

describe 'module', ->
  # asserts for paths
  paths =
    dirs:
      'controllers/': yes
      'views/': yes
      'views/album/': yes
      'views/album/slider/': yes
      'views/album/slider/templates/': yes
      'engines/': yes
      'engines/rounds/': yes
      'ia/': yes
      'ia/killer/': yes

    files:
      'controllers/base-controller.coffee': yes
      'controllers/album-controller.coffee': yes
      'views/': yes
      'views/albums-collection-view.coffee': yes
      'views/album/': yes
      'views/album/album-view.coffee': yes
      'views/album/slider/': yes
      'views/album/slider/slider-view.coffee': yes
      'views/album/slider/templates/': yes
      'views/album/slider/templates/slider.hbs': yes
      # not configurated module type
      'engines/': yes
      'engines/game.coffee': yes
      'engines/rounds/': yes
      'engines/rounds/first.coffee': yes
      'modules/': yes
      'modules/robot.coffee': yes
      'ia/': yes
      'ia/killer/': yes
      'ia/killer/killer.coffee': yes

  settings = extend(yes, {
    paths:
      app: ''
  }, Preprocessor::defaults)

  # override module::isDir in order to test from asserts
  Module::isDir = (path) ->
    paths.dirs[path]? and paths.dirs[path] is true

  # override module::fileExists in order to test from asserts
  Module::fileExists = (path) ->
    paths.files[path]? and paths.files[path] is true

  tests = []

  tests.push
    isVendor: no
    location: 'controller.base'
    path: 'controllers/base-controller'
    varName: 'BaseController'

  tests.push
    isVendor: no
    location: 'controller.album'
    path: 'controllers/album-controller'
    varName: 'AlbumController'

  tests.push
    isVendor: no
    location: 'view.album'
    path: 'views/album/album-view'
    varName: 'AlbumView'

  tests.push
    isVendor: no
    location: 'collectionView.albums'
    path: 'views/albums-collection-view'
    varName: 'AlbumsCollectionView'

  tests.push
    isVendor: no
    location: 'view.album.slider'
    path: 'views/album/slider/slider-view'
    varName: 'AlbumSliderView'

  tests.push
    isVendor: no
    location: 'template.album.slider'
    path: 'views/album/slider/templates/slider'
    varName: 'AlbumSliderTemplate'

  # vendor

  tests.push
    isVendor: yes
    location: 'jquery'
    varName: 'Jquery'

  tests.push
    isVendor: yes
    location: 'chaplin'
    varName: 'Chaplin'

  tests.push
    isVendor: yes
    location: 'chaplin/lib/router'
    varName: 'ChaplinLibRouter'

  for test in tests
    do (test) ->
      module = new Module
        isVendor: test.isVendor
        location: test.location
      , settings, settings.paths.app

      it 'should be instantied', ->
        expect(module).to.be.an.instanceof Module

      it 'should find the file path of ' + test.location, ->
        expect(module.findPath()).to.be.true

        it 'should find the correct file path', ->
          expect(module.path).to.equal 'controllers/base-controller'

      it 'should generate the correct var name', ->
        expect(module.getVarName()).to.equal test.varName
