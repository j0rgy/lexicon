require_relative './lexicon/parser.rb'

Pair = Struct.new(:token, :word)

class Lexicon

	def initialize()

		@pairs = { "north" => :direction, "south" => :direction, "east" => :direction, "west" => :direction,
			"go" => :verb, "stop" => :verb, "kill" => :verb, "eat" => :verb,
      "the" => :stop, "in" => :stop, "of" => :stop, "from" => :stop, "at" => :stop, "it" => :stop,
      "door" => :noun, "bear" => :noun, "princess" => :noun, "cabinet" => :noun, "room" => :noun }

   # @structs = []
   # @pairs.each { |pair| @structs << Pair.new(pair[1], pair[0]) }
 
	end

	def convert_number(s)
		begin
			Integer(s)
		rescue ArgumentError
			nil
		end
	end

	def scan(input)
		sentence = []
		words = input.split()
		words.each do |word|
			if @pairs.include?(word.downcase)
				sentence << Pair.new(@pairs[word.downcase], word.downcase)
			elsif convert_number(word)
				sentence << Pair.new(:number, word.to_i)
			else
				sentence << Pair.new(:error, word)
			end
		end
		sentence
	end

end