require 'console'

class BarGeoflipper < ActiveRecord::Base
  self.table_name = 'bar_geoflipper'

  def self.paris_bars
    uri = URI.parse('http://geoflipper.fr/category/france/ile-de-france/paris/')
    doc = Net::HTTP.get_response(uri).body.gsub(/(\n|\t)/, '')
    doc.scan(/var point(.*?)createMarker/).map(&:first).each do |text|
      Console.log(bar_infos(text))
      create_bar(bar_infos(text))
    end
    true
  end

  def self.bar_infos(text)
    zde = {
      name: /(?<=var the_title = ')(.*?)(?='\;)/,
      url: /(?<=var the_link = ')(.*?)(?='\;)/,
      lat: /(?<=LatLng\()(.*?)(?=, )/,
      lng: /(?<=, )(.*?)(?=\)\;)/
    }
    zde.each { |k, v| zde[k] = v.match(text).to_s }
  end

  def self.create_bar(infos)
    bar = find_or_create_by(url: infos[:url])
    bar[:name] = infos[:name]
    bar[:latitude] = infos[:lat]
    bar[:longitude] = infos[:lng]
    bar.save
  end
end
