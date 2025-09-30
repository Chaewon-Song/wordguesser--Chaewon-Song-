require 'sinatra'
require_relative 'lib/wordguesser_game'

enable :sessions

get '/' do
  redirect '/new'
end

post '/new' do
  word = WordGuesserGame.get_random_word
  session[:game] = WordGuesserGame.new(word)
  redirect '/show'   # 새 게임 시작 후 show 페이지로 이동
end

post '/guess' do
  letter = params[:guess].to_s
  @game = session[:game]

  begin
    result = @game.guess(letter)
    if result == false
      @message = "You have already used that letter."
    end
  rescue ArgumentError
    @message = "Invalid guess."
  end

  session[:game] = @game
  erb :show
end

get '/show' do
  @game = session[:game]
  erb :show
end
