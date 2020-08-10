#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'pry'
require 'scraped'

require_relative 'lib/quickstatement_candidate'

json_file = ARGV.first
json = JSON.parse(File.read(json_file), symbolize_names: true)
csv = CSV.table(json[:combofile])

commands = csv.map do |row|
  data = row.to_h
  data[:id] ||= data.delete(:foundid)
  QuickStatement::Candidate.new(
    data.merge(election: json[:wikidata], url: json[:wikipedia][:url], description: json[:new_person_description])
  ).to_s
end

puts commands.join("\n")
