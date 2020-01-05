require 'strscan'

#
# Lexer
# Responsible for creating tokens from the template string
# [[:TOKEN, value]]
#
class Lexer
  def initialize
    @stack = []
    @tokens = []
  end

  # @param [string] template
  # @return [Array] tokens
  def self.tokenize(template)
    new.tokenize(template)
  end


  # @param [string] template
  # @return [Array] tokens
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

  attr_accessor :stack, :tokens
  attr_reader :scanner

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
    elsif scanner.scan(identifier_regex)
      identifier(scanner.matched)
    end
  end

  def identifier_regex
    %r{
      \s*           # Can have any number of space after braces
      [a-z_]        # Starting of variable can contain a-z or underscore
      [a-zA-Z_0-9]* # Variable may contain a-z, A-Z, 0-9 or underscore, can have any number of occurrence
      \s*           # Can have any number of space before braces
    }x
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

  def identifier(identifier)
    tokens << [:IDENTIFIER, identifier.strip]
  end
end
