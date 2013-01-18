require 'digest/sha1'

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
      reply = "#{body['xml']['Location_X']}, #{body['xml']['Location_Y']}, #{body['xml']['Label']}"
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
          x.cdata body['xml']['MsgType']
        }
        x.Content {
          x.cdata reply
        }
        x.FuncFlag("0")
      }
    end
  end
end
