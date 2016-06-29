require 'httparty'
require 'dotenv'
Dotenv.load

def extract(str)
  body = {
    request_id: "record001",
    sentence: str,
    class_filter: "ART|ORG|PSN|LOC|DAT|TIM"
  }

  response = HTTParty.post("https://api.apigw.smt.docomo.ne.jp/gooLanguageAnalysis/v1/entity?APIKEY=#{ENV['APIKEY']}", body: body)
  result = JSON.parse(response.body)

  date = nil
  time = nil
  result['ne_list'].each do |val, cate|
    date = val if cate == 'DAT'
    time = val if cate == 'TIM'
  end

  DateTime.parse("#{date} #{time}")
end

puts extract("今度のご飯だけど7/10の20:15はどう？").strftime("%Y/%m/%d %H:%M")
