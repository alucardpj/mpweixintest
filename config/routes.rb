Mpweixintest::Application.routes.draw do
  get "weixins"   => "weixins#auth"
  
  scope "/", via: :post do
    match "weixins" => "weixins#reply_text", constraints: Weixin::Router.new("text")
    match "weixins" => "weixins#reply_image", constraints: Weixin::Router.new("image")
    match "weixins" => "weixins#reply_location", constraints: Weixin::Router.new("location")
    match "weixins" => "weixins#reply_link", constraints: Weixin::Router.new("link")
    match "weixins" => "weixins#reply_event", constraints: Weixin::Router.new("event")
    match "weixins" => "weixins#reply_music", constraints: Weixin::Router.new("music")
    match "weixins" => "weixins#reply_news", constraints: Weixin::Router.new("news")
    match "weixins" => "weixins#reply_news", constraints: lambda {|r| r.params}
  end
end
