
module.exports = class Preprocessor
  brunchPlugin: yes
  type: 'javascript'
  extension: 'coffee'

  constructor: (@conf) ->


  include: ( ) ->
    paths = [ ]
    for own key, value of @conf.plugins.vendorize
      p = key
      if value.include?
        p = key + '/' + value.include
      paths.push(require.resolve(p))
    paths

#####
# EOF
