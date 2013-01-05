class MyAPI < Grape::API
  version 'v1', :using => :path
  format :xml

  desc "validation"
  get do
    params[:echostr]
  end

  desc "reply"
  post do

    {
      :xml => {
        :ToUserName => "<![CDATA[toUser]]>",
        :FromUserName => "<![CDATA[fromUser]]>",
        :CreateTime => "12345678",
        :MsgType => "<![CDATA[text]]>",
        :Content => "<![CDATA[content]]>",
        :FuncFlag => "0"
      }
    }
  end
end