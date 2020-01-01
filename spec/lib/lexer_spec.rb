describe Lexer do
  let(:lexer) { described_class }

  it 'detects content expression' do
    template = 'hello, {{name}}'

    tokens = lexer.tokenize(template)

    expect(tokens[0][0]).to eq(:CONTENT)
    expect(tokens[0][1]).to eq('hello, ')

    expect(tokens[1][0]).to eq(:OPEN_EXPRESSION)

    expect(tokens[2][0]).to eq(:CONTENT)
    expect(tokens[2][1]).to eq('name')

    expect(tokens[3][0]).to eq(:CLOSE_EXPRESSION)
  end
end
