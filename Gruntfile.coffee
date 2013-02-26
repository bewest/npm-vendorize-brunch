module.exports = (grunt) ->

  # Package
  # =======
  pkg = require './package.json'

  # Configuration
  # =============
  grunt.initConfig

    # Package
    # -------
    pkg: pkg

    # Clean
    # -----
    clean:
      temp: 'lib'
      test: ['test/temp*']

    # Compilation
    # -----------
    coffee:
      compile:
        files: [
          expand: true
          dest: 'lib/'
          cwd: 'src'
          src: '**/*.coffee'
          ext: '.js'
        ]

      test:
        files: [
          expand: true
          dest: 'test/temp/'
          cwd: 'test/spec'
          src: '**/*.coffee'
          ext: '.js'
        ]

      options:
        bare: true

    # Watcher
    # -------

    watch:
      src:
        files: 'src/*.coffee'
        tasks: ['coffee:compile']
        options:
          interrupt: true

    copy:
      test:
        files: [
          expand: true
          dest: 'test/temp/'
          cwd: 'lib'
          src: '**/*.js'
        ]

    # Test runner
    # -----------
    simplemocha:
      options: {}

      src: [
        'test/temp/*.js'
      ]

    # Lint
    # ----
    coffeelint:
      source: 'src/*.coffee'
      test: 'test/**/*.coffee'
      grunt: 'Gruntfile.coffee'

  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  # Compile
  grunt.registerTask 'build', [
    'coffee:compile'
  ]

  # Lint
  # ----
  grunt.registerTask 'lint', 'coffeelint'

  # Test
  # ----
  grunt.registerTask 'test', [
    'clean'
    'coffee:compile'
    'coffee:test'
    'copy:test'
    'simplemocha'
    'clean:test'
  ]
