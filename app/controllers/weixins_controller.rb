class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def auth
    render :text => params[:echostr]
  end

  def reply_text
    @reply = params[:xml][:Content]
    #render "reply", formats: :xml
    #render "musicreply", formats: :xml
    @articles = []
    3.times.each do |e|
      news = News.new
      news.title = e.to_s
      news.description = e.to_s
      news.picurl = "http://www.muu.com.cn/img/d/848aae3922f63684f34cc09f91f86bb4a1a5d7ea791bc2a8bd9fc90ae2f70f8f92d1d271fc28d9b6.jpg"
      news.url = "http://www.baidu.com"
      @articles << news
    end
    render "newsreply", formats: :xml
  end

  def reply_image
    render "reply", formats: :xml
  end

  def reply_location
    url = "http://api.map.baidu.com/geocoder?location=#{params[:xml][:Location_X]},#{params[:xml][:Location_Y]}&output=json&key=9d303595cfbaa7f96ab0e7f56c1fd29f"
    result = JSON::parse(Net::HTTP.get(URI(url)))
    @reply = result["result"]["formatted_address"]
    render "reply", formats: :xml
  end

  def reply_link
    render "reply", formats: :xml
  end

  def reply_event
    render "reply", formats: :xml
  end

  def reply_music
    render "reply", formats: :xml
  end

  def reply_news
    render "reply", formats: :xml
  end

  private
  def check_weixin_legality
    array = [Setting.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
