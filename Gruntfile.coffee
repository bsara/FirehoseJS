'use strict';

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    # Metadata.
    pkg: grunt.file.readJSON 'package.json'

    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',


    # Task configuration.

    clean:
      files: ['dist', 'build/src']

    bump:
      options:
        commit: false
        createTag: false
        push: false

    coffee:
      app:
        options:
          bare: true
          preserve_dirs: true
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'build/src/'
          ext: '.js'
        ]
      test:
        options:
          bare: true
          preserve_dirs: true
        files: [
          expand: true
          cwd: 'test/'
          src: ['**/*.coffee']
          dest: 'build/test'
          ext: '.js'
        ]

    concat:
      all:
        src: (->
          root = 'build/src'
          files = []
          files.push "firehose"
          files.push "lib/private/unique_array"
          files.push "lib/private/remote_array"
          files.push "lib/private/environment"
          files.push "lib/private/client"
          files.push "lib/private/object"
          files.push "lib/agent"
          files.push "lib/company"
          files.push "lib/interaction"
          files.push "lib/agent_invite"
          files.push "lib/attachment"
          files.push "lib/canned_response"
          files.push "lib/cloud_file"
          files.push "lib/credit_card"
          files.push "lib/customer"
          files.push "lib/customer_account"
          files.push "lib/email_account"
          files.push "lib/email_interaction"
          files.push "lib/facebook_account"
          files.push "lib/facebook_interaction"
          files.push "lib/facebook_page"
          files.push "lib/note"
          files.push "lib/notification"
          files.push "lib/outgoing_attachment"
          files.push "lib/product"
          files.push "lib/tag"
          files.push "lib/twitter_account"
          files.push "lib/twitter_interaction"
          files.push "lib/article"
          sources = []
          sources.push 'stripe/stripe.js'
          for file in files
            sources.push "#{root}/#{file}.js"
          sources
        )()
        dest: 'dist/firehose.js'

    copy:
      test:
        src: 'test/firehosejs_tests.html'
        dest: 'build/test/firehosejs_tests.html'

    exec:
      generate_docs:
        command: 'codo'
      start_server:
        command: 'sh ./test/start_server.sh'
      kill_server:
        command: 'sh ./test/kill_server.sh'
      open_browser:
        command: 'open http://localhost:4011/build/test/firehosejs_tests.html'

    connect:
      test:
        options:
          port: 4011
          base: '.'
      debug:
        options:
          port: 4011
          base: '.'
          keepalive: true

    qunit:
      all:
        options:
          timeout: 15000
          urls: ['http://localhost:4011/build/test/firehosejs_tests.html']

    uglify:
      options:
        mangle: false
        banner: '<%= banner %>'
      dist:
        src: 'dist/firehose.js'
        dest: 'dist/firehose.min.js'

    watch:
      gruntfile:
        files: '<%= jshint.gruntfile.src %>'
        tasks: ['jshint:gruntfile']
      src:
        files: ['src/**/*.coffee']
        tasks: ['jshint:src', 'qunit']
      test:
        files: '<%= jshint.test.src %>'
        tasks: ['jshint:test', 'qunit']
      build:
        files: ['src/**/*.coffee']
        tasks: ['clean', 'coffee:app', 'concat:all', 'uglify']


  grunt.event.on 'qunit.moduleStart', (name) ->
    grunt.log.writeln("")
    grunt.log.ok("Testing: #{name}");

  # grunt.event.on 'qunit.testStart', (name) ->
  #   grunt.log.ok("Started #{name}");

  grunt.event.on 'qunit.testDone', (name, failed, passed, total) ->
    if passed
      grunt.log.ok("Passed: #{name}");
    else
      grunt.log.error("Failed: #{name}");


  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-bump'

  # Default task.
  grunt.registerTask 'default', ['test']
  grunt.registerTask 'test', ['clean', 'exec:generate_docs', 'coffee', 'concat', 'copy', 'exec:start_server', 'connect:test', 'qunit', 'exec:kill_server', 'uglify']
  grunt.registerTask 'build', ['clean', 'exec:generate_docs', 'coffee', 'concat', 'copy', 'uglify']
  grunt.registerTask 'debug', ['clean', 'coffee', 'concat', 'copy', 'exec:start_server', 'exec:open_browser', 'connect:debug']
  # grunt.registerTask 'noserver', ['clean', 'coffee', 'concat', 'copy', 'connect:test', 'qunit' ]
  grunt.registerTask 'noserver', ['clean', 'coffee', 'concat', 'copy', 'exec:open_browser', 'connect:debug' ]