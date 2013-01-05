class MyAPI < Grape::API
  version 'v1', :using => :path
  format :xml

  desc "validation"
  get do
    params[:echostr]
  end

  desc "reply"
  post do
    builder = Nokogiri::XML::Builder.new do |x|
      x.xml() {
        x.ToUserName {
          x.cdata params[:xml][:ToUserName]
        }
        x.FromUserName {
          x.cdata params[:xml][:FromUserName]
        }
        x.CreateTime Time.now.to_i.to_s
        x.MsgType {
          x.cdata params[:xml][:MsgType]
        }
        x.Content {
          x.cdata "content"
        }
        x.FuncFlag("0")
      }
    end
  end
end