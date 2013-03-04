# -*- encoding : utf-8 -*-
module Weixin
  # 微信内部路由规则类，用于简化配置
  class Router

    def initialize(type="text")
      @message_type = type
    end

    def matches?(request)
      xml_data = request.params[:xml]
      if xml_data and xml_data.is_a?(Hash)
        @message_type == request.params[:xml][:MsgType]
      end
    end
  end

  module ActionController
    # 辅助方法，用于简化操作，weixin_xml.content 比用hash舒服多了，对不？
    def weixin_xml
      @weixin_xml ||= WeixinXml.new(params[:xml])
      return @weixin_xml
    end

    class WeixinXml
      attr_accessor :content, :type, :from_user, :to_user, :pic_url
      def initialize(hash)
        @content = hash[:Content]
        @type = hash[:MsgType]
        @from_user = hash[:FromUserName]
        @to_user = hash[:ToUserName]
        @pic_url = hash[:PicUrl]
      end
    end
  end
end

ActionController::Base.class_eval do
  include ::Weixin::ActionController
end

ActionView::Base.class_eval do
  include ::Weixin::ActionController
end