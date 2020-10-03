# frozen_string_literal: true

require 'optimist'
require_relative '../lib/afinus'
require 'pry'

opts = Optimist.options do
  opt :recursive, 'Clean directories recursively'
  opt :dir, 'Working directory', default: Dir.pwd, type: :string
end

AFI.new.execute!(opts.dir, recursive: opts.recursive)