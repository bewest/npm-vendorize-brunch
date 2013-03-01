var Module, Preprocessor, coffeescript, extend,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
      /*
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
      */

      collectionView: {
        path: 'views',
        suffix: 'collection-view'
      },
      config: {
        path: 'config',
        suffix: 'config'
      },
      controller: {
        path: 'controllers',
        suffix: 'controller'
      },
      composition: {
        path: 'compositions',
        suffix: 'composition'
      },
      helper: {
        path: 'helpers',
        suffix: 'helper'
      },
      lib: {
        path: 'lib',
        varNameWithFilename: true
      },
      model: {
        path: 'models',
        varNameWithoutType: true
      },
      template: {
        path: 'views',
        subFolder: 'templates',
        extension: 'hbs'
      },
      view: {
        path: 'views',
        suffix: 'view'
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
    this.onRequireMatch = __bind(this.onRequireMatch, this);
    this.appPath = config.paths.app + '/';
    this.modules = {};
    this.initialize(config.preprocessor);
  }

  /**
   * Initialize plugin.
   * @return void
  */


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

  /**
   * Initialize regexes.
   * @return void
  */


  Preprocessor.prototype.prepareRegexes = function() {
    this.regexes = {};
    this.prepareRegexRequire();
    return this.prepareRegexExport();
  };

  /**
   * Initialize require regex.
   * @return void
  */


  Preprocessor.prototype.prepareRegexRequire = function() {
    var regexString;
    regexString = "([a-z0-9\\.0-9_-]+ = )?";
    regexString += "(";
    regexString += this.escapeRegExp(this.settings.naming.prefixApp);
    regexString += "|";
    regexString += this.escapeRegExp(this.settings.naming.prefixVendor);
    regexString += ")";
    regexString += "(";
    regexString += this.escapeRegExp(this.settings.naming.require);
    regexString += "|";
    regexString += this.escapeRegExp(this.settings.naming.include);
    regexString += ") ";
    regexString += "([a-z\\.0-9_-]+[0-9a-z_-]+)$";
    return this.regexes.require = new RegExp(regexString, 'gi');
  };

  /**
   * Initialize export regex.
   * @return void
  */


  Preprocessor.prototype.prepareRegexExport = function() {
    var regexString;
    regexString = "^class ([a-z0-9_-]+)";
    return this.regexes["export"] = new RegExp(regexString, 'gi');
  };

  /**
   * Wrap the preprocessor in this function.
   * This is the only actual way to compile before coffeescript
   * with a brunch plugin.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  */


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

  /**
   * Start the Compilator.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  */


  Preprocessor.prototype.preprocess = function(data, path, callback) {
    data = this.preprocessRequires(data, path, callback);
    if (this.settings["export"] != null) {
      data = this.preprocessExports(data, path, callback);
    }
    return data;
  };

  /**
   * Compile the modules declarations.
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  */


  Preprocessor.prototype.preprocessRequires = function(data, filePath, callback) {
    data = data.replace(this.regexes.require, this.onRequireMatch);
    return data;
  };

  /**
   * Callback of require regex match
   * @param  array match
   * @param  string varName
   * @param  string isVendor
   * @param  string method
   * @param  string moduleLocation
   * @return string requireDeclaration
  */


  Preprocessor.prototype.onRequireMatch = function(match, varName, isVendor, method, moduleLocation) {
    var error, module, _require;
    if (this.modules[moduleLocation] != null) {
      module = this.modules[moduleLocation];
    } else {
      module = new Module({
        isVendor: this.settings.naming.prefixVendor === isVendor,
        location: moduleLocation
      }, this.settings, this.appPath);
      this.modules[moduleLocation] = module;
    }
    if (!module.findPath()) {
      error = "couldn't locate " + moduleLocation + " at path " + module.path;
      throw new Error(error);
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
  };

  /**
   * Compile the module.exports = class MyClass
   * @param  string data
   * @param  string filePath
   * @param  function callback
   * @return string data
  */


  Preprocessor.prototype.preprocessExports = function(data, filePath, callback) {
    var _this = this;
    data = data.replace(this.regexes["export"], function(match, className) {
      var content;
      content = _this.settings["export"] + ' = ' + match;
      return content;
    });
    return data;
  };

  /**
   * Function from http://stackoverflow.com/a/6969486/1134411
   * @param  string str
   * @return string escapedString
  */


  Preprocessor.prototype.escapeRegExp = function(str) {
    return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  };

  return Preprocessor;

})();
