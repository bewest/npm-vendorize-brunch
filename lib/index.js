var NPMVendorize,
  __hasProp = {}.hasOwnProperty;

module.exports = NPMVendorize = (function() {

  NPMVendorize.prototype.brunchPlugin = true;

  NPMVendorize.prototype.type = 'javascript';

  NPMVendorize.prototype.extension = 'coffee';

  function NPMVendorize(conf) {
    this.conf = conf;
  }

  NPMVendorize.prototype.include = function() {
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

  return NPMVendorize;

})();
