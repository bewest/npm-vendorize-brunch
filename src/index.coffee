coffeescript = require 'coffee-script'
extend = require 'node.extend'
Module = require './module'

module.exports = class Preprocessor
	brunchPlugin: yes
	type: 'javascript'
	extension: 'coffee'

	defaults:
		beforeSuffix: '-'
		types:
			controller:
				path  : 'controllers'
				suffix: 'controller'
			view:
				path  : 'views'
				suffix: 'view'
			model:
				path: 'models'
				varNameWithoutType: yes
			collectionView:
				path  : 'views'
				suffix: 'collection-view'
			template:
				path  : 'views'
				subFolder: 'templates'
				extension: 'hbs'
			helper:
				path  : 'helpers'
				suffix: 'helper'
			config:
				path  : 'config'
				suffix: 'config'
			lib:
				path: 'lib'
				varNameWithFilename: yes

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

	initialize: (options) ->
		@settings = extend yes, {}, @defaults
		if options?
			for key, value of options
				@settings[key] = value if @settings[key]?

		@prepareRegexes()

	prepareRegexes: ->
		@regexes = {}
		@prepareRegexRequire()
		@prepareRegexExport()

	prepareRegexRequire: ->
		# optional variable name
		regexString  = "([a-zA-Z0-9\\.0-9_-]+ = )?"
		# type of include/require
		regexString += "(\\#{@settings.naming.prefixApp}|\\#{@settings.naming.prefixVendor})"
		# method
		regexString += "(#{@settings.naming.require}|#{@settings.naming.include}) "
		# module path
		regexString += "([a-zA-Z\\.0-9_-]+)"

		@regexes.require = new RegExp regexString, 'g'

	prepareRegexExport: ->
		regexString = "^class ([a-zA-Z0-9_-]+)"

		@regexes.export = new RegExp regexString, 'gm'

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

	preprocess: (data, path, callback) ->
		data = @preprocessRequires data, path, callback
		if @settings.export?
			data = @preprocessExports data, path, callback
		data

	preprocessRequires: (data, filePath, callback) ->

		data = data.replace @regexes.require, (match, varName, isVendor, method, moduleLocation) =>

			# check for already processed module
			if @modules[moduleLocation]?
				module = @modules[moduleLocation]
			else
				module = new Module
					isVendor: @settings.naming.prefixVendor is isVendor
					location: moduleLocation
				, @settings, @appPath
				@modules[moduleLocation] = module

			unless module.findPath()
				throw new Error "couldn't locate #{moduleLocation} at path #{module.path}"
				return

			_require = "require('#{module.path}')"

			if method is 'require'

				if varName?
					varName = varName.replace ' = ', ''
				else varName = module.getVarName()

				_require = "#{varName} = #{_require}"

			_require

		data

	preprocessExports: (data, filePath, callback) ->
		data = data.replace @regexes.export, (match, className) =>
			content = @settings.export + ' = ' + match
			content
		data