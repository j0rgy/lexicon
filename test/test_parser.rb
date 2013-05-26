require 'test/unit'
require_relative "../lib/lexicon"

class ParserTests < Test::Unit::TestCase

  @@lexicon = Lexicon.new

  def test_peek()
    sentence = @@lexicon.scan("kill the bear")
    assert_equal(:verb, Parser.peek(sentence))
  end

  def test_match()
    sentence = [Pair.new(:verb, 'run'), Pair.new(:noun, 'princess')]
    assert_equal(sentence[0], Parser.match(sentence, :verb))
  end

  def test_skip()  
    sentence = [Pair.new(:verb, 'go'), Pair.new(:verb, 'do')]
    Parser.skip(sentence, :verb)
    assert_equal([], sentence)
  end

  def test_parse_verb
    sentence = [Pair.new(:verb, 'run'), Pair.new(:noun, 'princess')]
    assert_equal(Pair.new(:verb, 'run'), Parser.parse_verb(sentence))

    sentence = [Pair.new(:noun, 'bear'), Pair.new(:verb, 'walk')]
    exception = assert_raise(ParserError) {Parser.parse_verb(sentence)}
    assert_equal("Expected a verb next.", exception.message)
  end

  def test_parse_object
    sentence = [Pair.new(:noun, "dolphin"), Pair.new(:verb, "shoot")]
    assert_equal(Pair.new(:noun, "dolphin"), Parser.parse_object(sentence))

    sentence = [Pair.new(:direction, "north"), Pair.new(:verb, "shoot")]
    assert_equal(Pair.new(:direction, "north"), Parser.parse_object(sentence))

    sentence = [Pair.new(:verb, "swim"), Pair.new(:noun, "gun")]
    exception = assert_raise(ParserError) {Parser.parse_object(sentence)}
    assert_equal("Expected a noun or direction next.", exception.message)
  end

  def test_parse_subject
    sentence = @@lexicon.scan("kill the bear")
    parsed_sentence = Parser.parse_subject(sentence, Pair.new(:noun, "player"))
    assert_equal("player", parsed_sentence.subject)


    subject = Pair.new(:noun, "player")
    verb = Pair.new(:verb, "kill")
    object = Pair.new(:noun, "bear")
    sentence = @@lexicon.scan("kill the bear")
    parsed = Sentence.new(subject, verb, object)
    result = [parsed.subject, parsed.verb, parsed.object]
    test_subject = Parser.parse_subject(sentence, Pair.new(:noun, "player"))
    assert_equal(result, [test_subject.subject, test_subject.verb, test_subject.object])
  end

  def test_parse_sentence
    subject = Pair.new(:noun, "player")
    verb = Pair.new(:verb, "kill")
    object = Pair.new(:noun, "bear")
    new_sentence = Sentence.new(subject, verb, object)
    result = [new_sentence.subject, new_sentence.verb, new_sentence.object]
    sentence = @@lexicon.scan("kill the bear")
    parsed = Parser.parse_sentence(sentence)
    assert_equal(result, [parsed.subject, parsed.verb, parsed.object])

    sentence = @@lexicon.scan("jibberish bear should be killed")
    exception = assert_raise(ParserError) {Parser.parse_sentence(sentence)}
    assert_equal("Must start with the subject, object or verb not: error", exception.message)
  end
end