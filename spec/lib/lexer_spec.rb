describe Lexer do
  let(:lexer) { described_class }

  it 'detects content expression with spaces' do
    template = 'hello, {{ name }}'

    tokens = lexer.tokenize(template)

    expect(tokens[0][0]).to eq(:CONTENT)
    expect(tokens[0][1]).to eq('hello, ')

    expect(tokens[1][0]).to eq(:OPEN_EXPRESSION)

    expect(tokens[2][0]).to eq(:IDENTIFIER)
    expect(tokens[2][1]).to eq('name')

    expect(tokens[3][0]).to eq(:CLOSE_EXPRESSION)
  end

  it 'detects content expression with out spaces' do
    template = 'hello, {{name}}'

    tokens = lexer.tokenize(template)

    expect(tokens[0][0]).to eq(:CONTENT)
    expect(tokens[0][1]).to eq('hello, ')

    expect(tokens[1][0]).to eq(:OPEN_EXPRESSION)

    expect(tokens[2][0]).to eq(:IDENTIFIER)
    expect(tokens[2][1]).to eq('name')

    expect(tokens[3][0]).to eq(:CLOSE_EXPRESSION)
  end

  it 'detects content expression with valid ruby variable' do
    template = 'hello, {{ _name1_X }} {{ age_8 }}'

    tokens = lexer.tokenize(template)

    expect(tokens[0][0]).to eq(:CONTENT)
    expect(tokens[0][1]).to eq('hello, ')

    expect(tokens[1][0]).to eq(:OPEN_EXPRESSION)

    expect(tokens[2][0]).to eq(:IDENTIFIER)
    expect(tokens[2][1]).to eq('_name1_X')

    expect(tokens[3][0]).to eq(:CLOSE_EXPRESSION)

    expect(tokens[4][0]).to eq(:CONTENT)
    expect(tokens[4][1]).to eq(' ')

    expect(tokens[5][0]).to eq(:OPEN_EXPRESSION)

    expect(tokens[6][0]).to eq(:IDENTIFIER)
    expect(tokens[6][1]).to eq('age_8')

    expect(tokens[7][0]).to eq(:CLOSE_EXPRESSION)
  end
end
