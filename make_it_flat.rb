# Problem 1 - Make It Flat
# Input : [1, 2, 3, [4, 6, [7, 8]], 5, 9, 10]
# output: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

def make_flat(array)
  result = array.each_with_object([]) do |element, flatten_array|
    flatten_array.push *(element.is_a?(Array) ? make_flat(element) : element)
  end
  sort_array(result)
end

# QuickSort
def sort_array(array)
  return array if array.length <= 1

  pivot_index = (array.length / 2).to_i
  pivot_value = array[pivot_index]
  array.delete_at(pivot_index)

  lesser = Array.new
  greater = Array.new

  array.each do |x|
    if x <= pivot_value
      lesser << x
    else
      greater << x
    end
  end
  sorted_array = sort_array(lesser) + [pivot_value] + sort_array(greater)
  sorted_array
end

print "output : "
p make_flat([1, 2, 3, [4, 6, [7, 8]], 5, 9, 10])


# Mini Test
require 'minitest/spec'
require 'minitest/autorun'

describe Array do
  it "should return flat array" do
    make_flat([1, 2, 3, [4, 6, [7, 8]], 5, 9, 10]).must_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  it "should return flat array with sorted order" do
    array = make_flat([10, 3, [4, 6, [7, 8]], 5, 9])
    array.last.must_equal 10
    array.first.must_equal 3
  end
end
