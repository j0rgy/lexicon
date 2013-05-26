class ParserError < Exception

end

class Sentence

	attr_reader :subject, :verb, :object

	def initialize(subject, verb, object)

		# remember we take Pair.new(:noun, "princess") structs and convert them
		@subject = subject.word
		@verb = verb.word
		@object = object.word
	end

end

module Parser

	  def self.peek(word_list) # Look at the next struct in the word list
  	begin
  		word_list.first.token # Return the token of the struct
  	rescue
  		nil # If there's an error, do nothing and keep going
  	end
  end

  def self.match(word_list, expecting) # Retur
  	begin
  		word = word_list.shift  # Remove the first word in the word list
  	  if word.token == expecting # If the token of the word matches the given parameter 'expecting', then return the word)
  	  	word
  	  else
  	  	nil  # Else, do nothing
  	  end
  	rescue
  		nil
  	end
  end

  # Why isn't skip working on its own? I can't get it to remove the element in the array that contains :stop,
  # but when I run 'parse_sentence' it works correctly. Maybe I should trace every step...

  def self.skip(word_list, token)
  	while peek(word_list) == token # If the next element of the word list matches the given token parameter,
  		match(word_list, token) # then remove the word from the array. Since 'match' doesn't have a 'return' in front of it, this
  		        								# while loop returns nothing, which is just what you'd want for a skip function.
  	end
  end

  def self.parse_verb(word_list)
  	skip(word_list, :stop)

  	if peek(word_list) == :verb
  		return match(word_list, :verb)
  	else
  		raise ParserError.new("Expected a verb next.")
  	end
  end

  def self.parse_object(word_list)
  	skip(word_list, :stop)
  	next_word = peek(word_list)

  	if next_word == :noun
  		return match(word_list, :noun)
  	end
  	if next_word == :direction
  		return match(word_list, :direction)
  	else
  		raise ParserError.new("Expected a noun or direction next.")
  	end
  end

  def self.parse_subject(word_list, subj)
  	verb = parse_verb(word_list)
  	obj = parse_object(word_list)

  	return Sentence.new(subj, verb, obj)
  end

  def self.parse_sentence(word_list)
    skip(word_list, :stop)

    start = peek(word_list)

    if start == :noun
    	subj = match(word_list, :noun)
    	return parse_subject(word_list, subj)
    elsif start == :verb
    	# assume the subject is the player then
    	return parse_subject(word_list, Pair.new(:noun, "player"))
    else
    	raise ParserError.new("Must start with the subject, object or verb not: #{start}")
    end
   end

 end
