Module = require './lib/module'

DirsPathsFixtures = require './fixtures/paths/dirs'
FilesPathsFixtures = require './fixtures/paths/files'

# override module::isDir in order to test from asserts
Module::isDir = (path) ->
  DirsPathsFixtures[path]? and DirsPathsFixtures[path] is true

# override module::fileExists in order to test from asserts
Module::fileExists = (path) ->
  FilesPathsFixtures[path]? and FilesPathsFixtures[path] is true
