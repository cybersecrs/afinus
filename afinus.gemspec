# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'afinus'
  s.version     = '1.5.1'
  s.summary     = 'Anti-Forensic-Investigation Null Script'
  s.description = <<~DESC
    AFINUS is ruby script to destroy data on device.
    This is useful if you want to sell your computer, but you want to be sure that buyer wouldn't be able to find your data.
    This simple script can make all your files non-recoverable even for experts, but if you work with high-sensitive data, you can also fill HD with random bytes (default 512kb).
  DESC
  s.authors = ['<name>']
  s.files   = ['lib/afinus.rb']
  s.homepage = 'https://github.com/cybersecrs/afinus'
  s.license = 'GPL-3.0-only'

  s.metadata['homepage_uri'] = 'https://github.com/cybersecrs/afinus'
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
