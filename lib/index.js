// Generated by CoffeeScript 1.3.3
(function() {
  var Module, Preprocessor, coffeescript, extend;

  coffeescript = require('coffee-script');

  extend = require('node.extend');

  Module = require('./module');

  module.exports = Preprocessor = (function() {

    Preprocessor.prototype.brunchPlugin = true;

    Preprocessor.prototype.type = 'javascript';

    Preprocessor.prototype.extension = 'coffee';

    Preprocessor.prototype.defaults = {
      beforeSuffix: '-',
      types: {
        controller: {
          path: 'controllers',
          suffix: 'controller'
        },
        view: {
          path: 'views',
          suffix: 'view'
        },
        model: {
          path: 'models',
          varNameWithoutType: true
        },
        collectionView: {
          path: 'views',
          suffix: 'collection-view'
        },
        template: {
          path: 'views',
          subFolder: 'templates',
          extension: 'hbs'
        },
        helper: {
          path: 'helpers',
          suffix: 'helper'
        },
        config: {
          path: 'config',
          suffix: 'config'
        },
        lib: {
          path: 'lib',
          varNameWithFilename: true
        }
      },
      naming: {
        require: 'require',
        include: 'include',
        prefixApp: '@',
        prefixVendor: '$'
      },
      "export": 'module.exports'
    };

    Preprocessor.prototype.appPath = null;

    Preprocessor.prototype.regexes = null;

    Preprocessor.prototype.settings = null;

    Preprocessor.prototype.modules = null;

    function Preprocessor(config) {
      this.appPath = config.paths.app + '/';
      this.modules = {};
      this.initialize(config.preprocessor);
    }

    Preprocessor.prototype.initialize = function(options) {
      var key, value;
      this.settings = extend(true, {}, this.defaults);
      if (options != null) {
        for (key in options) {
          value = options[key];
          if (this.settings[key] != null) {
            this.settings[key] = value;
          }
        }
      }
      return this.prepareRegexes();
    };

    Preprocessor.prototype.prepareRegexes = function() {
      this.regexes = {};
      this.prepareRegexRequire();
      return this.prepareRegexExport();
    };

    Preprocessor.prototype.prepareRegexRequire = function() {
      var regexString;
      regexString = "([a-zA-Z0-9\\.0-9_-]+ = )?";
      regexString += "(\\" + this.settings.naming.prefixApp + "|\\" + this.settings.naming.prefixVendor + ")";
      regexString += "(" + this.settings.naming.require + "|" + this.settings.naming.include + ") ";
      regexString += "([a-zA-Z\\.0-9_-]+)";
      return this.regexes.require = new RegExp(regexString, 'g');
    };

    Preprocessor.prototype.prepareRegexExport = function() {
      var regexString;
      regexString = "^class ([a-zA-Z0-9_-]+)";
      return this.regexes["export"] = new RegExp(regexString, 'gm');
    };

    Preprocessor.prototype.compile = function(data, path, callback) {
      var error, result;
      try {
        if (path.substr(0, 3) === 'app') {
          data = this.preprocess(data, path, callback);
        }
        return result = coffeescript.compile(data, {
          bare: true
        });
      } catch (err) {
        return error = err;
      } finally {
        callback(error, result);
      }
    };

    Preprocessor.prototype.preprocess = function(data, path, callback) {
      data = this.preprocessRequires(data, path, callback);
      if (this.settings["export"] != null) {
        data = this.preprocessExports(data, path, callback);
      }
      return data;
    };

    Preprocessor.prototype.preprocessRequires = function(data, filePath, callback) {
      var _this = this;
      data = data.replace(this.regexes.require, function(match, varName, isVendor, method, moduleLocation) {
        var module, _require;
        if (_this.modules[moduleLocation] != null) {
          module = _this.modules[moduleLocation];
        } else {
          module = new Module({
            isVendor: _this.settings.naming.prefixVendor === isVendor,
            location: moduleLocation
          }, _this.settings, _this.appPath);
          _this.modules[moduleLocation] = module;
        }
        if (!module.findPath()) {
          throw new Error("couldn't locate " + moduleLocation + " at path " + module.path);
          return;
        }
        _require = "require('" + module.path + "')";
        if (method === 'require') {
          if (varName != null) {
            varName = varName.replace(' = ', '');
          } else {
            varName = module.getVarName();
          }
          _require = "" + varName + " = " + _require;
        }
        return _require;
      });
      return data;
    };

    Preprocessor.prototype.preprocessExports = function(data, filePath, callback) {
      var _this = this;
      data = data.replace(this.regexes["export"], function(match, className) {
        var content;
        content = _this.settings["export"] + ' = ' + match;
        return content;
      });
      return data;
    };

    return Preprocessor;

  })();

}).call(this);