require 'terminal-table'

class BarMistergoodbeer < ActiveRecord::Base
  self.table_name = 'bar_mistergoodbeer'

  def self.fill_table
    doc = File.open('app/assets/sources/mistergoodbeer.html', 'r').read
    doc.scan(/gWindowContents0.push\((.*?)\)\;/).each do |bar_info|
      bar_info = bar_info.first
      infos = [
        ['name', bar_name(bar_info)],
        ['address', bar_address(bar_info)],
        ['price', bar_price(bar_info)],
        ['happyhour_open', bar_hh_open(bar_info)],
        ['happyhour_close', bar_hh_close(bar_info)],
        ['happyhour_price', bar_hh_price(bar_info)]
      ]
      puts Terminal::Table.new :rows => infos
      bar = Bar.find_by(name: bar_name(bar_info))
      bar ||= Bar.create(
        name: bar_name(bar_info),
        address: bar_address(bar_info),
        price: bar_price(bar_info),
        hh_open: bar_hh_open(bar_info),
        hh_close: bar_hh_close(bar_info),
        hh_price: bar_hh_price(bar_info)
      )
      find_by(bar_id: bar[:id]) || create(
        bar_id: bar[:id],
        url: bar_url(bar_info),
        name: bar_name(bar_info),
        address: bar_address(bar_info),
        price: bar_price(bar_info),
        hh_open: bar_hh_open(bar_info),
        hh_close: bar_hh_close(bar_info),
        hh_price: bar_hh_price(bar_info)
      )
    end
    true
  end

  def self.bar_name(bar_info)
    name = /(?<=fiche\\\/\d\\\">)(.*?)(?=<img)/.match(bar_info).to_s
    name = /(?<=fiche\\\/\d\d\\\">)(.*?)(?=<img)/.match(bar_info).to_s if name == ''
    name = /(?<=fiche\\\/\d\d\d\\\">)(.*?)(?=<img)/.match(bar_info).to_s if name == ''
    decode(name)
  end

  def self.bar_address(bar_info)
    address = /(?<=adresse\\\">)(.*?)(?=<)/.match(bar_info).to_s
    decode(address)
  end

  def self.bar_price(bar_info)
    price = /(?<=prix_sh\\\">)(.*?)(?= \\u20ac<)/.match(bar_info).to_s.gsub(',','.').to_f
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
    price = /(?<=prix_hh\\\">)(.*?)(?= \\u20ac en Happy hour<)/.match(bar_info).to_s.gsub(',','.').to_f
  end

  def self.bar_url(bar_info)
    mgb_id = /(?<=fiche\\\/)(.*?)(?=\\\">)/.match(bar_info).to_s
    "http://www.mistergoodbeer.com/bars/fiche/#{mgb_id}"
  end

  def self.decode(str)
    str.gsub('\u00e9', 'é')
      .gsub('\u00e0', 'à')
      .gsub('\u00e8', 'è')
      .gsub('\u00f4', 'ô')
      .gsub('\u00e2', 'â')
      .gsub('\u00e7', 'ç')
      .gsub('\u00ea', 'ê')
      .gsub('\u00fb', 'û')
      .gsub('\u00b4', '´')
      .gsub('\u00ed', 'í')
      .gsub('\u2030', '‰')
      .gsub('\u20ac', '€')
      .gsub('\u00a3', '£')
      .gsub('\u00c9', 'É')
      .gsub('\u00eb', 'ë')
  end
end