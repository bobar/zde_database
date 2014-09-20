require 'terminal-table'

class BarMistergoodbeer < ActiveRecord::Base
  self.table_name = 'bar_mistergoodbeer'

  def self.fill_table
    doc = File.open('app/assets/sources/mistergoodbeer.html', 'r').read
    doc.scan(/gWindowContents0.push\((.*?)\)\;/).each do |bar_info|
      bar_info = bar_info.first
      bar = Bar.find_by(name: bar_name(bar_info)) || create_bar(bar_info)
      find_by(bar_id: bar[:id]) || create_bar_mistergoodbeer(bar[:id], bar_info)
    end
    true
  end

  def self.create_bar(bar_info)
    Bar.create(
      name: bar_name(bar_info),
      address: bar_address(bar_info),
      price: bar_price(bar_info),
      hh_open: bar_hh_open(bar_info),
      hh_close: bar_hh_close(bar_info),
      hh_price: bar_hh_price(bar_info)
    )
  end

  def self.create_bar_mistergoodbeer(bar_id, bar_info)
    create(
      bar_id: bar_id,
      url: bar_url(bar_info),
      name: bar_name(bar_info),
      address: bar_address(bar_info),
      price: bar_price(bar_info),
      hh_open: bar_hh_open(bar_info),
      hh_close: bar_hh_close(bar_info),
      hh_price: bar_hh_price(bar_info)
    )
  end

  def self.bar_name(bar_info)
    name = /(?<=fiche\\\/\d\\\">)(.*?)(?=<img)/
      .match(bar_info).to_s
    name = /(?<=fiche\\\/\d\d\\\">)(.*?)(?=<img)/
      .match(bar_info).to_s if name == ''
    name = /(?<=fiche\\\/\d\d\d\\\">)(.*?)(?=<img)/
      .match(bar_info).to_s if name == ''
    decode(name)
  end

  def self.bar_address(bar_info)
    address = /(?<=adresse\\\">)(.*?)(?=<)/.match(bar_info).to_s
    decode(address)
  end

  def self.bar_price(bar_info)
    price = /(?<=prix_sh\\\">)(.*?)(?= \\u20ac<)/
      .match(bar_info)
      .to_s
      .gsub(',', '.')
      .to_f
    price > 0 ? price : nil
  end

  def self.bar_hh(bar_info)
    hh = /(?<=happyhour\\\">)(.*?)(?=<)/.match(bar_info).to_s
    hh == 'Happy hour: h - h' ? false : hh
  end

  def self.bar_hh_open(bar_info)
    hh = bar_hh(bar_info)
    hh ? /(?<=Happy hour: )(.*?)(?= -)/.match(hh).to_s : nil
  end

  def self.bar_hh_close(bar_info)
    hh = bar_hh(bar_info)
    hh ? /(?<= - )(.*)/.match(hh).to_s : nil
  end

  def self.bar_hh_price(bar_info)
    /(?<=prix_hh\\\">)(.*?)(?= \\u20ac en Happy hour<)/
      .match(bar_info)
      .to_s
      .gsub(',', '.')
      .to_f
  end

  def self.bar_url(bar_info)
    mgb_id = /(?<=fiche\\\/)(.*?)(?=\\\">)/.match(bar_info).to_s
    "http://www.mistergoodbeer.com/bars/fiche/#{mgb_id}"
  end

  def self.decode(str)
    {
      '\u00e9' => 'é', '\u00e0' => 'à',
      '\u00e8' => 'è', '\u00f4' => 'ô',
      '\u00e2' => 'â', '\u00e7' => 'ç',
      '\u00ea' => 'ê', '\u00fb' => 'û',
      '\u00b4' => '´', '\u00ed' => 'í',
      '\u2030' => '‰', '\u20ac' => '€',
      '\u00a3' => '£', '\u00c9' => 'É',
      '\u00eb' => 'ë'
    }.each { |k, v| str = str.gsub(k, v) }
  end

  def self.log(bar_info)
    log(bar_info)
    infos = [
      ['name', bar_name(bar_info)],
      ['address', bar_address(bar_info)],
      ['price', bar_price(bar_info)],
      ['happyhour_open', bar_hh_open(bar_info)],
      ['happyhour_close', bar_hh_close(bar_info)],
      ['happyhour_price', bar_hh_price(bar_info)]
    ]
    puts Terminal::Table.new rows: infos
  end
end
