require 'sinatra'
require 'wikipedia'
require 'wikicloth'
require 'json'
require 'sass'
require 'susy'

class WikiParser < WikiCloth::Parser
  # prepend /wiki to links and replace spaces with underscores
  url_for do |page|
    File.join("/wiki", page).gsub(" ", "_")
  end
  link_attributes_for do |page|
    { href: url_for(page) }
  end

  # replace spaces with underscores for images
  image_url_for do |url|
    url.gsub(" ", "_")
  end
end

def getPage(page)
  @wiki = Wikipedia.find(page)
  if @wiki.content  
    @content = WikiParser.new({
      data: @wiki.content
    }).to_html(noedit: true)
  end

  @image_urls = Hash.new
  @wiki.image_urls.each do |url|
    filename = url.rpartition("/").last 
    @image_urls[filename] = url
  end 
end

get '/' do
  erb :index 
end

get '/wiki/:page' do
  getPage(params[:page])
  erb :index
end

post '/' do
  getPage(params[:page])
  erb :index
end

get '/styles.css' do
  scss :styles, style: :compressed
end
