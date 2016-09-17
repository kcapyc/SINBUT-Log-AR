require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:log.db"

class Post < ActiveRecord::Base
	validates :author, presence: true, length: {in: 1..30}
	validates :content, presence: true, length: {minimum: 3}
end

class Comment <ActiveRecord::Base
	validates :content, presence: true, length: {minimum: 3}
	validates :author, presence: true, length: {in: 1..30}
end

get '/' do
	@posts = Post.order('created_at DESC') 
	erb :index
end

get '/css' do
  erb "CSS Docs is <a href='http://getbootstrap.com/css/' target='_blank'>here</a> and <a href='http://getbootstrap.com/components/' target='_blank'>here</a>. <a href='http://v4-alpha.getbootstrap.com/examples/' target='_blank'>Demo</a>"     
end

get '/newpost' do
	@newpost = Post.new
	erb :newpost
end

post '/newpost' do
	@newpost = Post.new params[:post]
	if @newpost.save
		redirect to '/'
	else
		@error = "Заполните все поля"
		erb :newpost
	end
end

get '/details/:post_id' do
	@results = Post.find(params[:post_id])
	@comments = Comment.where("post_id=?", params[:post_id]).order('created_at DESC')
	erb :details
end

post '/details/:post_id' do
	@newcomment = Comment.new params[:comment]
	@newcomment.post_id = params[:post_id]
	
	if @newcomment.save
		redirect to ('/details/' + params[:post_id])
	else
		@error = "Заполните все поля"
		redirect to ('/details/' + params[:post_id])
	end
end