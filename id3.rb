class Attribute

  def initialize(name, values)
    @name = name
    @values = values.clone
    @total_values = 0
    @hash_filtered_data = Hash.new
    @hash_count_values = Hash.new
  end

  def name
    @name
  end
  def total_values
    @total_values
  end

  def hash_filtered_data
    @hash_filtered_data
  end

  def hash_count_values
    @hash_count_values
  end

  def values
    @values
  end

  def set_depth(depth)
    @depth = depth
  end


  def filter_data(attribute_index, values, data)
    @hash_filtered_data = Hash.new {|h,k| h[k]=[]}
    values.each do |v|
      data.each do |d|
        if d[attribute_index] == v
          @hash_filtered_data[v] << d
        end
      end
    end
    count_data()
  end

  def count_data()
    @hash_count_values = Hash.new
    @hash_filtered_data.each do |k,v|
      @hash_count_values.merge!({k => v.length})
    end
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

def reduce_rows(data, attribute_index, value)
  filtered = []
  data.each do |row|
    if(row[attribute_index] == value)
      filtered.push(row)
    end
  end
  return filtered
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

def get_entropy(attributes, data)
  counter  = {}
  #puts "input entropy data #{data}"
  arr_to_hash(attributes, counter)
  size = data.size
  data.each do |row|
    val = row.last.to_s
    counter[val] = counter[val]+1
  end
  #puts "counter #{counter}"
  result = 0
  counter.each do |key, value|
    if (counter[key] > 0)
      proportion = value.to_f / size.to_f
      #puts "Proportion = #{value.to_f} / #{size.to_f}"
      neg_prop = proportion * -1
      result += neg_prop * Math.log2(proportion)
      #puts "TEMP ENTROPY result +=  #{neg_prop} * #{Math.log2(proportion)}"
    end
  end
  #puts "result #{result}"
  return result
end

def information_gain(data, h_total_entropy, attribute, attribute_index, last_attribute_values)
  result = 0
  attribute.values.each do |a_v|
    filtered_data = reduce_rows(data, attribute_index, a_v)
    #puts "filtered for #{a_v} in space #{attribute_index} \n data: #{filtered_data}"
    aux = get_entropy(last_attribute_values, filtered_data)
    result -= (aux * (filtered_data.length / data.length))
    #puts "formula = #{aux} * #{filtered_data.length} / #{data.length} "
    #puts "result info gain #{result}"
  end
  #puts "info gain #{h_total_entropy} - #{result}"
  return h_total_entropy + result

end


def split(attributes, data, last_attribute_values, h_total_entropy, visited, depth)
  max = 0
  chosen_position = -1
  attributes.each_with_index do |a, i|
    if(!visited.include?(i))
      aux = information_gain(data, h_total_entropy, a, i, last_attribute_values)
      if(aux > max)
        max = aux
        chosen_position = i
      end
    end
  end
  result = attributes[chosen_position]
  result.values.each do |v|
    filtered = reduce_rows(data, chosen_position, v)
    ##puts "chosing #{result.name} value: #{v}"
    puts "#{result.name} : #{v}"
    if(get_entropy(last_attribute_values, filtered) == 0)
      ##puts "answer: #{result.name} value #{v}"
      puts "#{"Answer: #{filtered[0].last}"}"
    else
      visited.push(result)
      split(attributes, filtered, last_attribute_values, h_total_entropy, visited, depth+1)
    end
  end
end


def main
  #parse attributes
  input = $stdin.readlines
  attributes = get_attributes(input)
  data = get_data(input)
  last_attribute = attributes.last
  attribute_index = attributes.index(last_attribute)
  last_attribute_values = last_attribute.values
  last_attribute.filter_data(attribute_index, last_attribute_values, data)
  h_total_entropy = get_entropy(last_attribute_values, data)
  depth = 0
  visited = []
  split(attributes, data, last_attribute_values, h_total_entropy, visited, depth)
end

main
