module Enumerable
  def my_each(&block)
    return to_enum(:my_each) unless block_given?

    if is_a? Range
      k = 0
      each(&block)
      return self
    end
    k = 0
    length.times do
      yield(self[k])
      k += 1
    end
    self
  end

  def my_each_with_index(block = nil)
    return to_enum(:my_each_with_index) unless block_given?

    k = 0
    if is_a? Range
      k = 0
      each do |i|
        if !block.nil?
          block.call(i, k)
        else
          yield(i, k)
        end
        k += 1
      end
      return self
    end
    length.times do
      if !block.nil?
        block.call(self[k], k)
      else
        yield(self[k], k)
      end
      k += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    final = []
    num = [Hash, Range].member?(self.class) ? to_a : self
    k = 0
    count do
      final << num[k] if yield(num[k])
      k += 1
    end
    final
  end

  def my_all?(block = nil)
    my_each do |rep|
      if block_given?
        return false unless yield rep
      elsif block.instance_of?(Class)
        return false unless rep.instance_of?(block)
      elsif !block.nil?
        return false unless rep == block
      elsif block.instance_of?(Regexp)
        return false unless block =~ rep
      else
        return false unless rep
      end
    end
    true
  end

  def my_any?(block = nil)
    my_each do |rep|
      if block_given?
        return true if yield rep
      elsif !block.nil?
        return true if rep == block
      elsif block.instance_of?(Class)
        return true if rep.instance_of?(block)
      elsif block.instance_of?(Regexp)
        return true if block =~ rep
      else
        return true unless rep
      end
    end
    return true if block.nil? && !block_given?

    false
  end

  def my_none?(block = nil)
    stat = false
    stat = true if length.zero?
    i = 0
    if block_given?
      length.times do
        stat = true unless yield (self[i])
        i += 1
      end
    elsif !block.nil?
      length.times do
        begin
          stat = true if self[i].is_a?(block)
        rescue StandardError
          stat = true if self[i].scan(block)
        end
        i += 1
      end
    else
      length.times do
        return true if self[i] == true
        return true if self[i] == self[i].nil?

        i += 1
      end
    end
    stat
  end

  def my_count
    num = 0
    if block_given?
      my_each { |i| num += 1 if yield(i) }
    elsif !num.nil?
      my_each { |i| num += 1 if i == num }
    else
      num = num.length
    end
    num
  end

  def my_map(block = nil)
    arr1 = []
    arr2 = []
    x = 0
    arr2 = if arr2 == to_a
             self
           else
             to_a
           end
    if !block.nil?
      arr2.my_each do
        arr1.push(block.call(arr2[x]))
        x += 1
      end
    else
      arr2.my_each do
        arr1.push(yield(arr2[x]))
        x += 1
      end
    end
    arr1
  end

  def my_inject(block = nil)
    arr2 = if arr2 == to_a
             self
           else
             to_a
           end
    if !block.nil?
      arr2.my_inject { |addi, x| addi + x }
    elsif block_given?
      add = arr2[0]
      arr2.my_each_with_index do |x, i|
        add = yield(add, x) if i != 0
      end
      add
    end
  end
end

def multiply_els(arr)
  arr.my_inject { |x, y| x * y }
end
