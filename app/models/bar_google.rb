require 'terminal-table'

class BarGoogle < ActiveRecord::Base
  self.table_name = 'bar_google'

  def self.fill_table
    Bar.find_each do |bar|
      next if find_by(bar_id: bar[:id])
      google_place = place_api(bar)
      break if google_place == false
      next unless google_place
      log(google_place)
      update_bar(bar, google_place)
      create_google_bar(bar, google_place)
    end
    true
  end

  def self.update_bar(bar, google_place)
    bar[:name] = google_place['name']
    bar[:address] = google_place['formatted_address']
    bar[:latitude] = google_place['geometry']['location']['lat']
    bar[:longitude] = google_place['geometry']['location']['lng']
    bar.save
  end

  def self.create_google_bar(bar, google_place)
    create(
      bar_id: bar[:id],
      name: google_place['name'],
      address: google_place['formatted_address'],
      rating: google_place['rating'],
      latitude: google_place['geometry']['location']['lat'],
      longitude: google_place['geometry']['location']['lng'],
      types: google_place['types'].to_json,
      place_id: google_place['place_id'],
      old_id: google_place['id'])
  end

  def self.place_api(bar)
    uri = URI.parse('https://maps.googleapis.com/maps/api/place/textsearch/json')
    request_parameters = {
      query: "#{bar[:name]} Paris France",
      key: 'AIzaSyAXgCgpPKM09uYO7HRL23S2a6GD9Y3gNz0'
    }
    request_parameters[:address] = bar[:address] if bar[:address]
    uri.query = URI.encode_www_form(request_parameters)
    response = Net::HTTP.get_response(uri)
    api_response(JSON.parse(response.body))
  end

  def self.api_response(body)
    if body['status'] == 'OVER_QUERY_LIMIT'
      puts body['status']
      puts body['error_message']
      return false
    end
    body['results'][0]
  end

  def self.log(google_place)
    puts Terminal::Table.new rows: [
      ['name', google_place['name']],
      ['address', google_place['formatted_address']],
      ['rating', google_place['rating']],
      ['latitude', google_place['geometry']['location']['lat']],
      ['longitude', google_place['geometry']['location']['lng']],
      ['types', google_place['types'].to_json],
      ['place_id', google_place['place_id']],
      ['old_id', google_place['id']]
    ]
  end
end
