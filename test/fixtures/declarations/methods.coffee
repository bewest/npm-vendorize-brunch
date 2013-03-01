Preprocessor = require '../../lib/preprocessor'

preprocessor = new Preprocessor
  paths:
    app: ''

appMethodRequire  = preprocessor.settings.naming.prefixApp
appMethodRequire += preprocessor.settings.naming.require

appMethodInclude  = preprocessor.settings.naming.prefixApp
appMethodInclude += preprocessor.settings.naming.include

vendorMethodRequire  = preprocessor.settings.naming.prefixVendor
vendorMethodRequire += preprocessor.settings.naming.require

vendorMethodInclude  = preprocessor.settings.naming.prefixVendor
vendorMethodInclude += preprocessor.settings.naming.include

module.exports =
  appMethodRequire: appMethodRequire
  appMethodInclude: appMethodInclude
  vendorMethodRequire: vendorMethodRequire
  vendorMethodInclude: vendorMethodInclude
