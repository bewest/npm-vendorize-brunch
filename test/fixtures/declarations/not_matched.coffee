methods = require './methods'

module.exports =
  require: [
    "MyVar = #{methods.appMethodRequire} \"module\""
    "MyVar = #{methods.vendorMethodRequire} \"module\""
    "MyVar = #{methods.appMethodInclude} \"module\""
    "MyVar = #{methods.vendorMethodInclude} \"module\""

    "#{methods.appMethodRequire} \"module\""
    "#{methods.vendorMethodRequire} \"module\""
    "#{methods.appMethodInclude} \"module\""
    "#{methods.vendorMethodInclude} \"module\""

    "MyVar = #{methods.appMethodRequire} module."
    "MyVar = #{methods.vendorMethodRequire} module."
    "MyVar = #{methods.appMethodInclude} module."
    "MyVar = #{methods.vendorMethodInclude} module."

    "#{methods.appMethodRequire} module."
    "#{methods.vendorMethodRequire} module."
    "#{methods.appMethodInclude} module."
    "#{methods.vendorMethodInclude} module."
  ]
  export: [
    "module.exports = class MyClass"
    " = class MyClass"
    "= class MyClass"
    " class MyClass"
  ]
