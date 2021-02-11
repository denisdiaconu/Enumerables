module Enumerables
  def my_each
    k = 0
    length.times do
      yield(self[k]) if block_given?
      k += 1
    end
    self
  end

  def my_each_with_index
    k = 0
    length.times do
      yield(self[k], k)
      k += 1
    end
    self
  end

  def my_select
    return to_enum(:my_each) unless block_given?

    arr = []
    length.times do |k|
      arr << self[k] if yield(self[k])
    end
    print arr
  end

  def my_all
    stat = true
    i = 0
    if block_given?
      length.times do
        stat = false unless yield(self[i])
        i += 1
      end
    end
    stat
  end

  def my_any
    stat = false
    return stat if length.zero?

    each do |k|
      stat = true if yield(self[k])
    end
    stat
  end

  def my_none
    stat = false
    i = 0
    if block_given?
      length.times do
        stat = true unless yield (self[i])
        i += 1
      end
    else
      length.times do
        return true if self[i] == true
      end
    end
    stat
  end

  def my_count
    num = 0
    if block_given?
      my_each { |i| num += 1 if yield(i) }
    else
      num = num.length
    end
    num
  end

  def my_map(block = nil)
    i = 0
    final = []
    if block_given?
      length.times do
        final.push(yield self[i])
        i += 1
      end
    elsif !block.nil?
      length.times do
        final.push(block.call(self[i]))
        i += 1
      end
    end
    final
  end

  def my_inject
    sum = 1
    i = 0
    if block_given?
      length.times do
        sum = yield(sum, self[i])
        i += 1
      end
    end
    sum
  end
end

def multiply_els(arr)
  arr.my_inject { |x, y| x * y }
end
