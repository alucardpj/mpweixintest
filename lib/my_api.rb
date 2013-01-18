require 'digest/sha1'
require 'net/http'

class MyAPI < Grape::API
  version 'v1', :using => :path
  format :xml
  content_type :xml, "text/xml"

  helpers do
    def checksignature(signature, timestamp, nonce)
      array = [Setting.token, timestamp, nonce].sort
      signature == Digest::SHA1.hexdigest(array.join)
    end
  end

  desc "validation"
  get do
    if checksignature(params[:signature], params[:timestamp], params[:nonce])
      params[:echostr]
    end
  end

  desc "reply"
  post do
    body = Hash.from_xml(request.body.read)
    status("200")
    case body['xml']['MsgType']
    when "text"
      reply = body['xml']['Content']
    when "location"
      url = "http://api.map.baidu.com/geocoder?location=#{body['xml']['Location_X']},#{body['xml']['Location_Y']}&output=json&key=9d303595cfbaa7f96ab0e7f56c1fd29f"
      result = JSON::parse(Net::HTTP.get(URI(url)))
      reply = result["result"]["formatted_address"]
    end
    builder = Nokogiri::XML::Builder.new do |x|
      x.xml() {
        x.ToUserName {
          x.cdata body['xml']['FromUserName']
        }
        x.FromUserName {
          x.cdata body['xml']['ToUserName']
        }
        x.CreateTime Time.now.to_i.to_s
        x.MsgType {
          x.cdata "text"
        }
        x.Content {
          x.cdata reply
        }
        x.FuncFlag("0")
      }
    end
  end
end
