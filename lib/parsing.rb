module Parsing
  def regex(text, zde)
    zde.each { |k, v| zde[k] = /(?<=#{v[0]})(.*?)(?=#{v[1]})/.match(text).to_s }
  end
end
