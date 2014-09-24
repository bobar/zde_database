module Console
  def self.log(infos)
    rows = infos.each { |k, v| [k, v] }
    puts Terminal::Table.new rows: rows
  end
end