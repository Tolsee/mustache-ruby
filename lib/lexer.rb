require 'strscan'
require 'pry'

# Lexer is responsible for creating tokens from the template string
#
class Lexer
  attr_accessor :stack, :tokens
  attr_reader :scanner

  def initialize
    @stack = []
    @tokens = []
  end

  def self.tokenize(template)
    new.tokenize(template)
  end

  def tokenize(template)
    @scanner = StringScanner.new(template)

    until @scanner.eos?
      if state == :default
        default_state
      elsif state == :expression
        expression_state
      end
    end

    tokens
  end

  private

  def default_state
    if scanner.scan(/{{/)
      open_expression
      push_state(:expression)
    elsif scanner.scan_until(/.*?(?={{)/m)
      content(scanner.matched)
    end
  end

  def expression_state
    if scanner.scan(/}}/)
      close_expression
      pop_state
    elsif scanner.scan(/[\w]+/)
      content(scanner.matched)
    end

  end

  def push_state(current_state)
    stack.push(current_state)
  end

  def pop_state
    stack.pop
  end

  def state
    stack.last || :default
  end

  def open_expression
    tokens << [:OPEN_EXPRESSION]
  end

  def close_expression
    tokens << [:CLOSE_EXPRESSION]
  end

  def content(content)
    tokens << [:CONTENT, content]
  end
end
