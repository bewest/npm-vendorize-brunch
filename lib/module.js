var Module, fs, inflection, sysPath;

fs = require('fs');

inflection = require('inflection');

sysPath = require('path');

module.exports = Module = (function() {

  Module.prototype.location = null;

  Module.prototype.type = null;

  Module.prototype.filename = null;

  Module.prototype.parentPath = null;

  Module.prototype.name = null;

  Module.prototype.localized = false;

  Module.prototype.path = null;

  Module.prototype.fullPath = null;

  Module.prototype.varName = null;

  Module.prototype.config = null;

  Module.prototype.settings = null;

  function Module(params, settings, appPath) {
    var parts;
    this.location = params.location;
    this.isVendor = params.isVendor;
    this.settings = settings;
    this.appPath = appPath;
    parts = this.location.split('.');
    if (parts.length === 1) {
      this.type = this.filename = this.location;
    } else {
      this.type = parts.shift();
      this.filename = parts.pop();
      if (parts.length > 0) {
        this.parentPath = parts.join('/');
      }
    }
    this.name = this.filename.split('-').join('_');
  }

  /**
   * Find the path of the module.
   * @return BOOL pathHasBeenFound
  */


  Module.prototype.findPath = function() {
    var candidatePath, candidatePaths, _i, _len, _ref;
    if (this.localized) {
      return this.isVendor || this.fileExists(this.fullPath);
    }
    if (this.isVendor || !(this.settings.types[this.type] != null)) {
      this.path = this.location.split('.').join('/');
      if (!this.isVendor) {
        this.fullPath = this.path + '.coffee';
      } else {
        this.fullPath = this.path;
        this.localized = true;
        return true;
      }
    } else {
      this.config = this.settings.types[this.type];
      this.path = this.config.path + '/';
      if (this.parentPath != null) {
        this.path += this.parentPath + '/';
      }
      candidatePaths = this.getCandidateFolders();
      for (_i = 0, _len = candidatePaths.length; _i < _len; _i++) {
        candidatePath = candidatePaths[_i];
        if (this.fileExists(candidatePath)) {
          if (this.isDir(candidatePath)) {
            this.path = candidatePath;
            break;
          }
        }
      }
      this.path += this.filename;
      if ((this.config.suffix != null) && this.config.suffix !== this.filename) {
        this.path += this.settings.beforeSuffix + this.config.suffix;
        this.filename += this.settings.beforeSuffix + this.config.suffix;
      }
      this.fullPath = this.path + '.' + ((_ref = this.config.extension) != null ? _ref : 'coffee');
    }
    this.localized = true;
    return this.fileExists(this.fullPath);
  };

  /**
   * Get the candidate paths from the path, filename and type configuration
   * @return array candidatePaths
  */


  Module.prototype.getCandidateFolders = function() {
    var candidatePaths;
    candidatePaths = [];
    if (this.config.subFolder != null) {
      candidatePaths.push(this.path + this.filename + '/' + this.config.subFolder + '/');
      candidatePaths.push(this.path + this.config.subFolder + '/');
    } else {
      candidatePaths.push(this.path + this.filename + '/');
      candidatePaths.push(this.path);
    }
    return candidatePaths;
  };

  /**
   * Get the variable name generated.
   * @return string varName
  */


  Module.prototype.getVarName = function() {
    if (this.varName == null) {
      this.generateVarName();
    }
    return this.varName;
  };

  /**
   * Generate the variable name from the path and the filename.
   * @return void
  */


  Module.prototype.generateVarName = function() {
    var typeName, varNameWithFilename, varNameWithType;
    varNameWithFilename = (this.config != null) && this.config.varNameWithFilename;
    if (!varNameWithFilename) {
      varNameWithType = (this.config != null) && (this.config.varNameWithoutType != null) ? !this.config.varNameWithoutType : true;
      if (varNameWithType) {
        typeName = inflection.underscore(this.type.split('-').join('_'), true);
        if (this.name !== typeName) {
          this.name += '_' + typeName;
        }
      }
      if (this.parentPath != null) {
        this.name = this.parentPath + '_' + this.name;
      }
    }
    this.name = this.name.replace(/\//g, '_');
    return this.varName = inflection.camelize(this.name);
  };

  /**
   * Check if a dir exists.
   * @param string dirPath
   * @return BOOL isDirectory
  */


  Module.prototype.isDir = function(path) {
    var stats;
    stats = fs.statSync(this.pathResolve(path));
    return stats.isDirectory();
  };

  /**
   * Check if a file exists.
   * @param  string filePath
   * @return BOOL fileExists
  */


  Module.prototype.fileExists = function(path) {
    return fs.existsSync(this.pathResolve(path));
  };

  /**
   * Make sure we working with an app path.
   * @param  string path
   * @return string pathResolved
  */


  Module.prototype.pathResolve = function(path) {
    path = sysPath.resolve(process.cwd(), this.appPath + path);
    return path;
  };

  return Module;

})();
