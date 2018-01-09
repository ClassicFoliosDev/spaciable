# frozen_string_literal: true

module CommunityFixture
  module_function

  def topic_1
    "First topic"
  end

  def content
    "Lorem ipsum dolor and I forgot what the rest is"
  end

  def topic_2
    "Second topic"
  end

  def reply
    "Responding to first topic"
  end

  def long_topic
    "A topic with a very long title that will break the one hundred character limit because it has been written with more than one hundred characters"
  end

  def long_content
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
    labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
    nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit
    esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt
    in culpa qui officia deserunt mollit anim id est laborum."
  end
end

