# frozen_string_literal: true

begin
  require_relative '../ext/inchi-gem/inchi'
rescue LoadError
  require 'inchi'
end
require 'inchi-gem/version'
