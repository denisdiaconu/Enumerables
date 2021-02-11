module Enumerable
  def my_each(block = nil)
    k = 0
    if block_given?
      length.times do
        if !block.nil?
          block.call(self[k])
        else
          yield(self[k])
        end
        k += 1
      end
    else
      self
    end
  end

  def my_each_with_index(block = nil)
    k = 0
    if block_given?
      length.times do
        if !block.nil?
          block.call(self[k], k)
        else
          yield(self[k], k)
        end
        k += 1
      end
    else
      self
    end
  end

  def my_select(block = nil)
    k = 0
    if block_given?
      length.times do
        if !block.nil?
          print self[k] if block.call(self[k])
        elsif yield(self[k])
          print self[k]
        end
        k += 1
      end
    else
      my_each
    end
  end

  def my_all(_block = nil)
    stat = true
    i = 0
    if block_given?
      length.times do
        stat = false unless yield(self[i])
        i += 1
      end
    else
      length.times do
        begin
          stat = false if self[i].is_a?
        rescue StandardError
          stat = false if self[i].scan
        end
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

  def my_none(_block = nil)
    stat = false
    stat = true if length.zero?
    i = 0
    if block_given?
      length.times do
        stat = true unless yield (self[i])
        i += 1
      end
    elsif !match.nil?
      length.times do
        begin
          stat = true if self[i].is_a?
        rescue StandardError
          stat = true if self[i].scan
        end
        i += 1
      end
    else
      length.times do
        return true if self[i] == true

        i += 1
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
    if !block.nil?
      length.times do
        final.push(block.call(self[i]))
        i += 1
      end
    elsif block_given?
      length.times do
        final.push(yield self[i])
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
