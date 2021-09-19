# frozen_string_literal: true

# operator class
class Operator
  @@operators = {
    '+' => {
      'precedence' => 2,
      'operation' => ->(a, b) { a + b }
    },
    '-' => {
      'precedence' => 2,
      'operation' => ->(a, b) { a - b }
    },
    '*' => {
      'precedence' => 3,
      'operation' => ->(a, b) { a * b }
    },
    '/' => {
      'precedence' => 3,
      'operation' => ->(a, b) { a / b }
    },
    '^' => {
      'precedence' => 4,
      'operation' => ->(a, b) { a**b }
    },
    '(' => {
      'precedence' => -1
    },
    ')' => {
      'precedence' => -1
    }

  }

  def self.token_operator?(op_name)
    !!(@@operators[op_name])
  end

  def self.precedence?(op1, op2)
    @@operators[op1]['precedence'] >= @@operators[op2]['precedence']
  end

  def self.do(num1, num2, operator)
    @@operators[operator]['operation'].call(num2, num1)
  end
end

# resolves math expression
class Yard
  def self.resolve(expression)
    tokens = tokenize(expression)
    parsed = parse(tokens)
    calc(parsed)
  end

  def self.tokenize(expression)
    first_pass = ''
    expression.split('').each_with_index do |c, index|
      first_pass += c
      add_space = (expression.length - 1 > index &&
                    (Operator.token_operator?(expression[index + 1]) && string_number?(c)) ||
                    (Operator.token_operator?(c) && string_number?(expression[index + 1])))
      # puts "c=#{c} index=#{index} add_space=#{add_space}"
      first_pass += ' ' if add_space
    end
    first_pass.split(' ')
  end

  def self.parse(tokens)
    output = []
    stack = []

    tokens.each do |token|
      if string_number? token
        output.push(token)
      elsif Operator.token_operator?(token)
        if stack.empty? || token == '('
          stack.push(token)
        elsif token == ')'
          output.push(stack.pop) while !stack.empty? && stack[-1] != '('
          raise 'expecting opening brace' unless !stack.empty? && stack[-1] == '('

          stack.pop
        else
          output.push(stack.pop) while !stack.empty? && Operator.precedence?(stack[-1], token)
          stack.push(token)
        end
      end
      # p "stack = #{stack} output=#{output}"
    end
    output.push(stack.pop) until stack.empty?
    output
  end

  def self.calc(parsed_tokens)
    stack = []
    parsed_tokens.each do |token|
      if string_number? token
        stack.push(token)
      elsif Operator.token_operator? token
        num1 = stack.pop.to_f
        num2 = stack.pop.to_f
        stack.push Operator.do num1, num2, token
      else
        raise 'unknown operator exception'
      end
    end
    stack.pop
  end

  def self.string_number?(to_check)
    to_check.to_i.to_s == to_check
  end
end
