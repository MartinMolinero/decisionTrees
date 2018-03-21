class Attribute

  def initialize
    @values = Hash.new
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


def main
  puts "hello world"
end

main
