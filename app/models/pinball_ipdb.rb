require 'console'

class PinballIpdb < ActiveRecord::Base
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
    Console.log(infos(text))
    pinball = create_pinball(infos(text))
    return if find_by(pinball_id: pinball[:id])
    create(infos(text).merge(pinball_id: pinball[:id]))
  end

  def self.create_pinball(infos)
    pinball = Pinball.find_or_create_by(name: infos[:name])
    pinball.update(
      manufacturer: infos[:manufacturer],
      year: infos[:year]
    )
    pinball
  end

  def self.infos(text)
    general_infos(text).merge(rating_infos(text))
  end

  def self.general_infos(text)
    {
      ipdb_id: /(?<=id=)(.*?)(?=\">)/.match(text).to_s,
      name: /(?<=<B>)(.*?)(?=<\/B>)/.match(text).to_s,
      manufacturer: /(?<=<font size=-2><I>by )(.*?)(?=<\/I>)/.match(text).to_s,
      year: /(?<=<font size=-1>)(.*?)(?=<\/font>)/.match(text).to_s
    }
  end

  def self.rating_infos(text)
    zde = {
      rating: %r{(?<=<td nowrap>&nbsp\;)(.*?)(?=<font size=-2>\/10<\/font>)},
      rating_art: %r{(?<=<em>Art:<\/em>)(.*?)(?=<\/font>)},
      rating_audio: %r{(?<=<em>Audio:<\/em>)(.*?)(?=<\/font>)},
      rating_playfield: %r{(?<=<em>Playfield:<\/em>)(.*?)(?=<\/font>)},
      rating_gameplay: %r{(?<=<em>Fun:<\/em>)(.*?)(?=<\/font>)},
      ratings: /(?<=<td nowrap align=right><font size=-1>)(.*?)(?= ratings)/
    }
    zde.each { |k, v| zde[k] = v.match(text).to_s }
  end
end
