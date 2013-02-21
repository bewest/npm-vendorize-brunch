Module = require './module'
Preprocessor = require './preprocessor'
expect = require('chai').expect

describe 'preprocessor', ->
  preprocessor = new Preprocessor
    paths:
      app: ''

  it 'should instantiate', ->
    expect(preprocessor).to.be.ok
    expect(preprocessor).to.be.an.instanceof Preprocessor

  it 'should have its regexes instantiated', ->
    expect(preprocessor.regexes.require).to.be.an.instanceof RegExp
    expect(preprocessor.regexes.export).to.be.an.instanceof RegExp

  describe 'regex require', ->

    appMethodRequire  = preprocessor.settings.naming.prefixApp
    appMethodRequire += preprocessor.settings.naming.require

    appMethodInclude  = preprocessor.settings.naming.prefixApp
    appMethodInclude += preprocessor.settings.naming.include

    vendorMethodRequire  = preprocessor.settings.naming.prefixVendor
    vendorMethodRequire += preprocessor.settings.naming.require

    vendorMethodInclude  = preprocessor.settings.naming.prefixVendor
    vendorMethodInclude += preprocessor.settings.naming.include

    declarations = []

    declarations.push "MyVar = #{appMethodRequire} my.module.path"
    declarations.push "MyVar = #{appMethodRequire} module"
    declarations.push "MyVar = #{vendorMethodRequire} my.module.path"
    declarations.push "MyVar = #{vendorMethodRequire} module"
    declarations.push "MyVar = #{appMethodInclude} my.module.path"
    declarations.push "MyVar = #{appMethodInclude} module"
    declarations.push "MyVar = #{vendorMethodInclude} my.module.path"
    declarations.push "MyVar = #{vendorMethodInclude} module"

    declarations.push "#{appMethodRequire} my.module.path"
    declarations.push "#{appMethodRequire} module"
    declarations.push "#{vendorMethodRequire} my.module.path"
    declarations.push "#{vendorMethodRequire} module"
    declarations.push "#{appMethodInclude} my.module.path"
    declarations.push "#{appMethodInclude} module"
    declarations.push "#{vendorMethodInclude} my.module.path"
    declarations.push "#{vendorMethodInclude} module"

    for declaration in declarations
      do (declaration) ->
        it 'should match declaration ' + declaration, ->
          matched = preprocessor.regexes.require.test(declaration)
          expect(matched).to.be.true

    declarations = []

    declarations.push "MyVar = #{appMethodRequire} \"module\""
    declarations.push "MyVar = #{vendorMethodRequire} \"module\""
    declarations.push "MyVar = #{appMethodInclude} \"module\""
    declarations.push "MyVar = #{vendorMethodInclude} \"module\""

    declarations.push "#{appMethodRequire} \"module\""
    declarations.push "#{vendorMethodRequire} \"module\""
    declarations.push "#{appMethodInclude} \"module\""
    declarations.push "#{vendorMethodInclude} \"module\""

    declarations.push "MyVar = #{appMethodRequire} module."
    declarations.push "MyVar = #{vendorMethodRequire} module."
    declarations.push "MyVar = #{appMethodInclude} module."
    declarations.push "MyVar = #{vendorMethodInclude} module."

    declarations.push "#{appMethodRequire} module."
    declarations.push "#{vendorMethodRequire} module."
    declarations.push "#{appMethodInclude} module."
    declarations.push "#{vendorMethodInclude} module."

    for declaration in declarations
      do (declaration) ->
        it 'should not match declaration ' + declaration, ->
          matched = preprocessor.regexes.require.test(declaration)
          expect(matched).to.be.false

  describe 'regex export', ->

    declarations = []

    declarations.push "class MyClass"
    declarations.push "class MyClass extends MyParentClass"

    for declaration in declarations
      do (declaration) ->
        it 'should match declaration ' + declaration, ->
          matched = preprocessor.regexes.export.test(declaration)
          expect(matched).to.be.true

    declarations = []

    declarations.push "module.exports = class MyClass"
    declarations.push " = class MyClass"
    declarations.push "= class MyClass"
    declarations.push " class MyClass"

    for declaration in declarations
      do (declaration) ->
        it 'should not match declaration ' + declaration, ->
          matched = preprocessor.regexes.export.test(declaration)
          expect(matched).to.be.false
