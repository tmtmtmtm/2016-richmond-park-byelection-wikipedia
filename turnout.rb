#!/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'open-uri'
require 'pry'
require 'uri'

class Wikitext
  def initialize(url)
    @url = url
  end

  def to_s
    json[:parse][:wikitext]
  end

  private

  attr_reader :url

  def api_url
    url.gsub('/wiki/', '/w/api.php?action=parse&format=json&prop=wikitext&formatversion=2&page=')
  end

  def response
    @response ||= URI.open(api_url).read
  end

  def json
    @json ||= JSON.parse(response, symbolize_names: true)
  end
end

url = ARGV.first
wikitext = Wikitext.new(url)

# We are ugly, but we have the music
turnout_box = wikitext.to_s.match(/{{Election box turnout(.*?)}}/m)
turnout = turnout_box.captures.first[/votes\s*=\s*([\d,]+)/m, 1].gsub(',', '')
puts turnout
