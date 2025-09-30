class WordGuesserGame
  attr_reader :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ''        # ✅ 문자열로 바꿔야 테스트 통과
    @wrong_guesses = ''  # ✅ 문자열로 바꿔야 테스트 통과
  end

  def guess(letter)
    raise ArgumentError, "No letter given" if !letter || letter.empty? || letter =~ /[^a-zA-Z]/
    letter = letter.downcase

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    elsif @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : "-" }.join
  end

  def win?
    word_with_guesses == @word
  end

  def lose?
    @wrong_guesses.length >= 7
  end

  def over?
    win? || lose?
  end

  def check_win_or_lose
    return :win if win?
    return :lose if lose?
    :play
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
