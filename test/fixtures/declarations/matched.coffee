methods = require './methods'

module.exports =
  require: [
    {
      before: "MyVar = #{methods.appMethodRequire} my.module.path"
      after: "MyVar = require('my/module/path')"
    }
    {
      before: "MyVar = #{methods.appMethodRequire} module"
      after: "MyVar = require('module')"
    }
    {
      before: "MyVar = #{methods.vendorMethodRequire} my.module.path"
      after: "MyVar = require('my/module/path')"
    }
    {
      before: "MyVar = #{methods.vendorMethodRequire} module"
      after: "MyVar = require('module')"
    }
    {
      before: "MyVar = #{methods.appMethodInclude} my.module.path"
      after: "require('my/module/path')"
    }
    {
      before: "MyVar = #{methods.appMethodInclude} module"
      after: "require('module')"
    }
    {
      before: "MyVar = #{methods.vendorMethodInclude} my.module.path"
      after: "require('my/module/path')"
    }
    {
      before: "MyVar = #{methods.vendorMethodInclude} module"
      after: "require('module')"
    }
    {
      before: "#{methods.appMethodRequire} my.module.path"
      after: "ModulePathMy = require('my/module/path')"
    }
    {
      before: "#{methods.appMethodRequire} module"
      after: "Module = require('module')"
    }
    {
      before: "#{methods.vendorMethodRequire} my.module.path"
      after: "ModulePathMy = require('my/module/path')"
    }
    {
      before: "#{methods.vendorMethodRequire} module"
      after: "Module = require('module')"
    }
    {
      before: "#{methods.appMethodInclude} my.module.path"
      after: "require('my/module/path')"
    }
    {
      before: "#{methods.appMethodInclude} module"
      after: "require('module')"
    }
    {
      before: "#{methods.vendorMethodInclude} my.module.path"
      after: "require('my/module/path')"
    }
    {
      before: "#{methods.vendorMethodInclude} module"
      after: "require('module')"
    }
  ]
  export: [
    {
      before: "class MyClass"
      after: "module.exports = class MyClass"
    }
    {
      before: "class MyClass extends MyParentClass"
      after: "module.exports = class MyClass extends MyParentClass"
    }
  ]
