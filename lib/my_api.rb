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
    Rails.logger.info body
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
          x.cdata body['xml']['Content']
        }
        x.FuncFlag("0")
      }
    end
    #Rails.logger.info builder.doc.root.to_xml
    #builder.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)
    # Rails.logger.info output
    #output
    #builder
  end
end