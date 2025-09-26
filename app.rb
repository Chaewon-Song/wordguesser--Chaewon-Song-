require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    erb :show   # ✅ 새 게임하면 바로 show 화면으로 가야 함
  end

  


  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    guess = params[:guess].to_s[0]   # 입력된 guess에서 첫 글자만 가져오기
    if !guess || guess !~ /^[a-zA-Z]$/   # 문자가 아니거나 빈 입력이면
      flash[:message] = "Invalid guess."
    elsif @game.guesses.include?(guess) || @game.wrong_guesses.include?(guess)
      flash[:message] = "You have already used that letter."
    else
      @game.guess(guess)
    end
    redirect '/show'
  end
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.

  get '/show' do
  if @game.win?
    redirect '/win'
  elsif @game.lose?
    redirect '/lose'
  else
    erb :show
  end
end


  get '/win' do
  redirect '/show'
  end

get '/lose' do
  redirect '/show'
  end


end
