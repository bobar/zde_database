require 'console'
require 'parsing'

class PinballGeoflipper < ActiveRecord::Base
  extend Console
  extend Parsing
  self.table_name = 'pinball_geoflipper'

  def self.fill_table
    BarGeoflipper.find_each { |bar| bar_pinballs(bar) }
  end

  def self.bar_pinballs(bar)
    return if find_by(bar_id: bar[:id])
    data = page_data(bar)
    bar.update(last_update: data[:update])
    data_pinballs = data[:pinball].scan(/<li>(.*?)<\/em>/)
    pinballs = data_pinballs.map { |plap| create_pinball(bar, plap[0]) }
    log(bar, data, pinballs)
  rescue Errno::ECONNRESET
    puts 'Pb de connexion'
  end

  def self.page_data(bar)
    uri = URI.parse(bar[:url])
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
    doc = res.body.gsub(/(\n|\t)/, '').force_encoding('UTF-8')
    regex(
      doc,
      pinball: ['<strong>Flip', '</ul>'],
      update: ['<span class=\"post-date\">Mise à jour le ', '</span>']
    )
  end

  def self.create_pinball(bar, string)
    name = pb_features(string)[:name]
    manufacturer = pb_features(string)[:manufacturer]
    pb = pinball_from_name(name, manufacturer)
    find_or_create_by(bar_id: bar[:id], pinball_id: pb[:id])
      .update(name: name, manufacturer: manufacturer)
    pb_hash = {}
    [:id, :name].each { |key| pb_hash["pb_#{key}"] = pb[key] }
    pb_hash[:name] = name
    pb_hash[:manufacturer] = manufacturer
    pb_hash
  end

  def self.pb_features(string)
    match_data = />(.*) <em>/.match(string) || /(.*) <em>/.match(string)
    name = match_data[1].gsub('</a>', '')
    manufacturer = /<em>(.*)/.match(string)[1]
    {
      name: name,
      manufacturer: manufacturer
    }
  end

  def self.pinball_from_name(name, manufacturer)
    pb = Pinball.find_by(name: name)
    pb ||= Pinball.where('name LIKE ?', "%#{name}%").first
    pb || Pinball.create(name: name, manufacturer: manufacturer)
  end

  def self.log(bar, data, pinballs)
    infos = [
      ['Id', bar[:id]],
      ['Bar', bar[:name]],
      ['Url', bar[:url]],
      ['Last update', data[:update]]
    ]
    puts Terminal::Table.new(rows: infos)
    infos = pinballs.map { |p| p.map { |_k, v| v } }
    headings = pinballs.first.to_a.map { |k, _v| k.to_s.camelcase }
    puts Terminal::Table.new(headings: headings, rows: infos)
  end
end
