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



def main
  #parse attributes
  input = $stdin.readlines
  attributes = get_attributes(input)
  data = get_data(input)
  puts "data #{data} attributes #{attributes}"


end

main
