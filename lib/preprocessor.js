var Preprocessor,
  __hasProp = {}.hasOwnProperty;

module.exports = Preprocessor = (function() {

  Preprocessor.prototype.brunchPlugin = true;

  Preprocessor.prototype.type = 'javascript';

  Preprocessor.prototype.extension = 'coffee';

  function Preprocessor(conf) {
    this.conf = conf;
  }

  Preprocessor.prototype.include = function() {
    var key, p, paths, value, _ref;
    paths = [];
    _ref = this.conf.plugins.vendorize;
    for (key in _ref) {
      if (!__hasProp.call(_ref, key)) continue;
      value = _ref[key];
      p = key;
      if (value.include != null) {
        p = key + '/' + value.include;
      }
      paths.push(require.resolve(p));
    }
    return paths;
  };

  return Preprocessor;

})();
