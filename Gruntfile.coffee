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
      tmp: 'lib'
      test: ['test/tmp*']

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
          dest: 'test/tmp/'
          cwd: 'test/spec'
          src: '**/*.coffee'
          ext: '.js'
        ]

      testFixtures:
        files: [
          expand: true
          dest: 'test/tmp/fixtures/'
          cwd: 'test/fixtures'
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
          dest: 'test/tmp/lib/'
          cwd: 'lib'
          src: '**/*.js'
        ]

    # Test runner
    # -----------
    simplemocha:
      options: {}

      src: [
        'test/tmp/*.js'
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
    'coffee:testFixtures'
    'copy:test'
    'simplemocha'
    'clean:test'
  ]
