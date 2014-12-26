require 'console'
require 'parsing'

class PinballIpdb < ActiveRecord::Base
  extend Console
  extend Parsing
  self.table_name = 'pinball_ipdb'

  def self.fill_table
    doc = File.open('app/assets/sources/ipdb.html', 'r').read
      .force_encoding('ISO-8859-1').encode('utf-8', replace: nil)
      .gsub(/(\n|\t)/, '')
    doc.scan(/<tr valign=top><td align=right nowrap>(.*?)<\/tr>/)
      .map(&:first).each do |text|
      process_pinball(text)
    end
    true
  end

  def self.process_pinball(text)
    log(infos(text))
    pinball = create_pinball(infos(text))
    return if find_by(pinball_id: pinball[:id])
    create(infos(text).merge(pinball_id: pinball[:id]))
  end

  def self.create_pinball(infos)
    pinball = Pinball.find_or_create_by(name: infos[:name])
    pinball.update(manufacturer: infos[:manufacturer], year: infos[:year])
    pinball
  end

  def self.infos(text)
    general_infos(text).merge(rating_infos(text))
  end

  def self.general_infos(text)
    regex(
      text,
      ipdb_id: ['id=', '\">'],
      name: ['<B>', '<\/B>'],
      manufacturer: ['<font size=-2><I>by ', '<\/I>'],
      year: ['<font size=-1>', '<\/font>']
    )
  end

  def self.rating_infos(text)
    regex(
      text,
      rating: ['<td nowrap>&nbsp\;', '<font size=-2>\/10<\/font>'],
      rating_art: ['<em>Art:<\/em>', '<\/font>'],
      rating_audio: ['<em>Audio:<\/em>', '<\/font>'],
      rating_playfield: ['<em>Playfield:<\/em>', '<\/font>'],
      rating_gameplay: ['<em>Fun:<\/em>', '<\/font>'],
      ratings: ['<td nowrap align=right><font size=-1>', ' ratings']
    )
  end
end
