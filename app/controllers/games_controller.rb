require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Generate random grid of letters
    @letters = []
    alphabet = ('A'..'Z').to_a
    10.times { @letters << alphabet.sample }
    return @letters
  end

  def score
    # binding.pry
    @word = params[:word]
    @letters = params[:letters]

    @message = gen_message(check_word(@word), check_grid(@word, @letters))
    return @message
  end

  def check_word(attempt)
    flag_word = true
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    attempt = JSON.parse(attempt_serialized)

    if attempt["found"] == true
    else
        flag_word = false
    end
    return flag_word
  end

  def check_grid(attempt, grid)
    attempt = attempt.upcase.split("")
    flag_grid = true

    grid = JSON.parse grid
    attempt.each do |letter|
      if grid.include?(letter)
        index_delete = grid.find_index(letter)
        grid.delete_at(index_delete)
      else flag_grid = false
      end
    end
    return flag_grid
  end

  def gen_message(flag_word, flag_grid)
    if flag_word == false && flag_grid == false
      message = "0. Sorry but your word does not exist and is not part of the grid : #{@letters}"
    elsif flag_word == false
      message = "0. Sorry but \"#{@word}\" is not an english word"
    elsif flag_grid == false
      message = "0. Sorry but \"#{@word}\" is not in the grid : #{@letters}"
    else
      message = "#{@word.length * 10}. Well done! \"#{@word}\" is a valid english word"
    end
    return message
  end
end
