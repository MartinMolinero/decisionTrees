class Attribute

  def initialize(name, values)
    @name = name
    @values = values.clone
    @total_values = 0
    @array_match_values = Hash.new
    @depth = -1
  end

  def total_values
    @total_values
  end

  def array_match_values
    @array_match_values
  end

  def values
    @values
  end

  def set_depth(depth)
    @depth = depth
  end

  def depth
    @depth
  end

end


def get_attributes(total_input)
  attributes = Array.new
  total_input.each do |line|

    if line.match(/@attribute\s.*/)
      attr_second = line.split(/@attribute\s(.*)\s/)
      attr_second = attr_second.join("")
      attr_second = attr_second.split(/\s/)
      name = attr_second[0]
      values = attr_second[1..-1].join("")
      values = values.gsub(/[{|}]/,'')
      values = values.split(",")
      a = Attribute.new(name, values)
      attributes.push(a)
    end
  end
  attributes
end

def get_data(total_input)
  data = Array.new
  read = false
  total_input.each do |line|
    line = line.chomp
    trueread = line.match(/@data(.)*/)
    if read and line[0] != '%'
      line = line.split(',')
      data.push(line)
    end

    if trueread
      read = true
    end
  end
  data
end


def arr_to_hash(arr, hash)
  arr.each do |value|
    hash.merge!({ value => 0 } )
  end
end

def get_initial_entropy(attributes, data)
  counter  = {}
  arr_to_hash(attributes, counter)
  puts "#{counter}"
  size = data.size
  data.each do |row|
    val = row.last.to_s
    counter[val] = counter[val]+1
  end
  result = 0
  counter.each do |key, value|
    proportion = value.to_f / size.to_f
    neg_prop = proportion * -1
    puts "#{neg_prop}"
    result += neg_prop * Math.log2(proportion)
  end
end




def main
  #parse attributes
  input = $stdin.readlines
  attributes = get_attributes(input)
  data = get_data(input)
  last_attribute = attributes.last
  last_attribute_values = last_attribute.values
  puts "data #{data} attributes #{attributes} \n last_attribute  #{last_attribute.inspect} values #{last_attribute_values}"
  h = get_initial_entropy(last_attribute_values, data)
  split(attributes)
end

main
