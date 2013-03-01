coffeescript = require 'coffee-script'
extend = require 'node.extend'
Module = require './module'

module.exports = class Preprocessor
  brunchPlugin: yes
  type: 'javascript'
  extension: 'coffee'

  defaults:
    # between the module name and the type suffix
    beforeSuffix: '-'

    # list of supported types
    types:

      ###
      # type:
      #
      # folder of all the types
      # ex: views
      #   path: string (required)
      #
      # Type suffix
      # ex: XX-controller
      #   suffix: string (required)
      #
      # generate variable name from filename
      # for example, you may not want the lib path in the variable name
      #   varNameWithFilename: BOOL (default: false)
      #
      # generate the variable name without type
      # for example model module name usually don't have the type in the name
      #   varNameWithoutType: BOOL (default: false)
      #
      # module default subfolder
      # ex: templates
      #   subFolder: string (default: null)
      #
      # file extension
      # ex: hbs
      #   extension: string (default: coffee)
      ###

      collectionView:
        path  : 'views'
        suffix: 'collection-view'
      config:
        path  : 'config'
        suffix: 'config'
      controller:
        path  : 'controllers'
        suffix: 'controller'
      composition:
        path  : 'compositions'
        suffix: 'composition'
      helper:
        path  : 'helpers'
        suffix: 'helper'
      lib:
        path: 'lib'
        varNameWithFilename: yes
      model:
        path: 'models'
        varNameWithoutType: yes
      template:
        path  : 'views'
        subFolder: 'templates'
        extension: 'hbs'
      view:
        path  : 'views'
        suffix: 'view'

    naming:
      require: 'require'
      include: 'include'
      prefixApp: '@'
      prefixVendor: '$'

    export: 'module.exports'

  appPath: null
  regexes: null
  settings: null
  modules: null

  constructor: (config) ->
    @appPath = config.paths.app + '/'
    @modules = {}
    @initialize config.preprocessor

  ###*
   * Initialize plugin.
   * @return void
  ###
  initialize: (options) ->
    @settings = extend yes, {}, @defaults
    if options?
      for key, value of options
        @settings[key] = value if @settings[key]?

    @prepareRegexes()

  ###*
   * Initialize regexes.
   * @return void
  ###
  prepareRegexes: ->
    @regexes = {}
    @prepareRegexRequire()
    @prepareRegexExport()

  ###*
   * Initialize require regex.
   * @return void
  ###
  prepareRegexRequire: ->
    # optional variable name
    # ex: MyVar =
    regexString  = "([a-z0-9\\.0-9_-]+ = )?"

    # type of include/require
    regexString += "("
    regexString += @escapeRegExp @settings.naming.prefixApp
    regexString += "|"
    regexString += @escapeRegExp @settings.naming.prefixVendor
    regexString += ")"

    # method
    regexString += "("
    regexString += @escapeRegExp @settings.naming.require
    regexString += "|"
    regexString += @escapeRegExp @settings.naming.include
    regexString += ") "

    # module path
    # ex: my.module.path
    # warning: it should not finish by a dot
    regexString += "([a-z\\.0-9_-]+[0-9a-z_-]+)$"

    @regexes.require = new RegExp regexString, 'gim'

  ###*
   * Initialize export regex.
   * @return void
  ###
  prepareRegexExport: ->
    regexString = "^class ([a-z0-9_-]+)"
    @regexes.export = new RegExp regexString, 'gim'

  ###*
   * Wrap the preprocessor in this function.
   * This is the only actual way to compile before coffeescript
   * with a brunch plugin.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  ###
  compile: (data, path, callback) ->
    try
      # only preprocess app files
      if path.substr(0, 3) is 'app'
        data = @preprocess data, path, callback
      # start coffeescript compiler
      result = coffeescript.compile data, bare: yes
    catch err
      error = err
    finally
      callback error, result

  ###*
   * Start the Compilator.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  ###
  preprocess: (data, path, callback) ->
    data = @preprocessRequires data, path, callback
    data = @preprocessExports data, path, callback if @settings.export?
    data

  ###*
   * Compile the modules declarations.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  ###
  preprocessRequires: (data, filePath, callback) ->
    data = data.replace @regexes.require, @onRequireMatch
    data

  ###*
   * Callback of require regex match
   * @param  array match
   * @param  string varName
   * @param  string isVendor
   * @param  string method
   * @param  string moduleLocation
   * @return string requireDeclaration
  ###
  onRequireMatch: (match, varName, isVendor, method, moduleLocation) =>
    # check for already processed module
    if @modules[moduleLocation]?
      module = @modules[moduleLocation]

    # new module
    else
      module = new Module
        isVendor: @settings.naming.prefixVendor is isVendor
        location: moduleLocation
      , @settings, @appPath
      @modules[moduleLocation] = module

    unless module.findPath()
      error = "couldn't locate #{moduleLocation} at path #{module.path}"
      throw new Error error
      return

    _require = "require('#{module.path}')"

    if method is 'require'

      if varName?
        varName = varName.replace ' = ', ''
      else varName = module.getVarName()

      _require = "#{varName} = #{_require}"

    _require

  ###*
   * Compile the module.exports = class MyClass
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  ###
  preprocessExports: (data, filePath, callback) ->
    data = data.replace @regexes.export, (match, className) =>
      content = @settings.export + ' = ' + match
      content
    data

  ###*
   * Function from http://stackoverflow.com/a/6969486/1134411
   * @param  string str
   * @return string escapedString
  ###
  escapeRegExp: (str) ->
    str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"
