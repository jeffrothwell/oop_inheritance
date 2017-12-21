require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist

  def initialize
    super
  end

  def report_total(numbers)
    total = numbers.sum
    say_in_local_language("The total is #{total}")
  end

end

class QuoteCollector < Multilinguist

  def initialize
    super
    @quotes = []
  end

  def save_quote(quote)
    @quotes << quote
  end

  def translate_random_quote
    quote = @quotes.sample
    say_in_local_language(quote)
  end

end

p jeff = MathGenius.new
# first in english
p jeff.report_total([23,54,654,86,3456,2,45])
# now in swedish
p jeff.travel_to('sweden')
p jeff.report_total([23,54,654,86,3456,2,45])

p jeff.travel_to('germany')
p jeff.report_total([23,54,654,86,3456,2,45])

p jeff.travel_to('spain')
p jeff.report_total([23,54,654,86,3456,2,45])

p moya = QuoteCollector.new

moya.save_quote("A rising tide floats all boats")
moya.save_quote("Better than a kick in the pants with a frozen boot")
moya.save_quote("A bird in the hand is worth two in the bush")

p moya.translate_random_quote

p moya.travel_to("finland")
p moya.translate_random_quote
p moya.travel_to("Italy")
p moya.translate_random_quote
p moya.travel_to("Germany")
p moya.translate_random_quote
