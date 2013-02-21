fs = require 'fs'
inflection = require 'inflection'
sysPath = require 'path'

module.exports = class Module

  location  : null
  type      : null
  filename  : null
  parentPath: null
  name      : null

  localized : no
  path      : null
  fullPath  : null

  varName : null

  config   : null
  settings : null

  constructor: (params, settings, appPath) ->
    @location = params.location
    @isVendor = params.isVendor
    @settings = settings
    @appPath  = appPath

    parts = @location.split '.'

    if parts.length is 1
      @type = @filename = @location
    else
      @type = parts.shift()
      @filename = parts.pop()
      @parentPath = parts.join('/') if parts.length > 0

    @name = @filename.split('-').join('_')

  findPath: ->
    return @isVendor or @fileExists @fullPath if @localized

    # vendor or unsupported type
    if @isVendor or not @settings.types[@type]?
      @path = @location.split('.').join('/')

      # do not check vendor path
      unless @isVendor
        @fullPath = @path + '.coffee'
      else
        @fullPath = @path
        @localized = yes
        return true

    else
      @config = @settings.types[@type]

      @path = @config.path + '/'

      # append parents path
      @path += @parentPath + '/' if @parentPath?

      candidatePaths = @getCandidateFolders()

      # if the path corresponds to an existing dir, the file should be inside
      for candidatePath in candidatePaths
        if @fileExists candidatePath
          if @isDir candidatePath
            @path = candidatePath
            break

      @path += @filename

      # add file suffix if configurated
      # don't append it if the filename is the suffix
      if @config.suffix? and @config.suffix isnt @filename
        @path += @settings.beforeSuffix + @config.suffix
        @filename += @settings.beforeSuffix + @config.suffix

      # add extension to the path to be able to test the existence
      @fullPath = @path + '.' + (@config.extension ? 'coffee')

    @localized = yes

    return @fileExists @fullPath

  getCandidateFolders: ->
    candidatePaths = []

    # should be in a subfolder?
    if @config.subFolder?

      # require {type}.{path}.{filename}

      # dedicated folder
      # {path}/{filename}/{subFolder}/{filename}.hbs
      candidatePaths.push @path + @filename + '/' + @config.subFolder + '/'

      # parent folder
      # {path}/{subFolder}/{filename}.hbs
      candidatePaths.push @path + @config.subFolder + '/'

    else
      # dedicated folder
      candidatePaths.push @path + @filename + '/'
      # parent folder
      candidatePaths.push @path

    candidatePaths

  getVarName: ->
    @generateVarName() unless @varName?
    @varName

  generateVarName: ->
    varNameWithFilename = @config? and @config.varNameWithFilename

    unless varNameWithFilename
      varNameWithType = if @config? and @config.varNameWithoutType?
        !@config.varNameWithoutType
      else
        yes

      # suffix activated
      if varNameWithType
        typeName = inflection.underscore @type.split('-').join('_'), yes # allUpperCase
        # the name of the file is not the suffix
        @name += '_' + typeName if @name isnt typeName

      @name = @parentPath + '_' + @name if @parentPath?

    # replace all slashes left
    @name = @name.replace(/\//g, '_')

    @varName = inflection.camelize @name

  isDir: (path) ->
    stats = fs.statSync @pathResolve path
    stats.isDirectory()

  fileExists: (path) ->
    fs.existsSync @pathResolve path

  pathResolve: (path) ->
    path = sysPath.resolve process.cwd(), @appPath + path
    path