# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'afinus'
  s.version     = '1.6.0'
  s.summary     = 'Anti-Forensic-Investigation Null Script'
  s.description = <<~DESC
    AFINUS is ruby gem to destroy data and clean device.
    All your files will be non-recoverable even for experts, but if you work with high-sensitive data, you can also fill HD with random bytes (default 512kb).
  DESC
  s.authors = ['Linuxander']
  s.files   = ['lib/afinus.rb']
  s.homepage = 'https://github.com/cybersecrs/afinus'
  s.license = 'GPL-3.0-only'

  s.metadata['homepage_uri'] = 'https://cybersecrs.github.io/afinus'
  s.metadata['source_code_uri'] = 'https://github.com/cybersecrs/afinus'
  s.metadata['bug_tracker_uri'] = 'https://github.com/cybersecrs/afinus/issues'

  s.files = ['bin/afinus', 'lib/afinus.rb', 'LICENSE', 'README.md', 'afinus.gemspec']
  s.bindir = 'bin'
  s.executables = ['afinus']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'colorize'
  s.add_runtime_dependency 'optimist'
  s.add_runtime_dependency 'pry'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
