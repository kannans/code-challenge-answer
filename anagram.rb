# Problem 1 - Anagram

module AreAnagrams
  def self.are_anagrams?(string_a, string_b)
    sorted_array(string_a) == sorted_array(string_b)
  end

  def self.sorted_array(string)
    string.split("").sort
  end
end

# Examples
puts "1. Check anagrams words: `orchestra`, `carthorse`:"
puts AreAnagrams.are_anagrams?("orchestra", "carthorse")

puts "2. Check anagrams words: `momdad`, `dadmom`:"
puts AreAnagrams.are_anagrams?("momdad", "dadmom")

puts "3. Check anagrams words: `test`, `codetest`:"
puts AreAnagrams.are_anagrams?("test", "codetest")

# Mini Test
require 'minitest/spec'
require 'minitest/autorun'

describe AreAnagrams do
  it "should return true, if words are anagrams" do
    AreAnagrams.are_anagrams?("orchestra", "carthorse").must_equal true
  end

  it "should return false, if words are not anagrams"  do
    AreAnagrams.are_anagrams?("orchestra", "test").must_equal false
  end

  it "should return sorted array given string"  do
    AreAnagrams.sorted_array("orchestra").must_equal ["a", "c", "e", "h", "o", "r", "r", "s", "t"]
  end

  it "should return false, if words are not anagrams"  do
    assert_raises ArgumentError do
      AreAnagrams.are_anagrams?("orchestra")
    end
  end
end
