module Enumerable
  def my_each(&block)
    return to_enum(:my_each) unless block_given?

    arr = [Hash, Range].member?(self.class) ? to_a.flatten : self
    if is_a? Range
      k = 0
      arr.each(&block)
      return self
    end
    k = 0
    arr.length.times do
      yield(arr[k])
      k += 1
    end
    self
  end

  def my_each_with_index(block = nil)
    return to_enum(:my_each_with_index) unless block_given?

    arr = [Hash, Range].member?(self.class) ? to_a.flatten : self
    k = 0
    if is_a? Range
      k = 0
      arr.each do |i|
        if !block.nil?
          block.call(i, k)
        else
          yield(i, k)
        end
        k += 1
      end
      return self
    end
    arr.length.times do
      if !block.nil?
        block.call(arr[k], k)
      else
        yield(arr[k], k)
      end
      k += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    final = []
    num = [Hash, Range].member?(self.class) ? to_a.flatten : self
    k = 0
    count do
      final << num[k] if yield(num[k])
      k += 1
    end
    final
  end

  def my_all?(block = nil)
    my_each do |re|
      if block_given?
        return false unless yield re
      elsif block.instance_of?(Regexp)
        return false unless block =~ re
      elsif block.instance_of?(Class)
        return false unless [re.class, re.class.superclass].include?(block)
      elsif !block.nil?
        return false unless re == block
      else
        return false unless re
      end
    end
    true
  end

  def my_any?(block = nil)
    return false if (self - [nil, false]) == []

    my_each do |re|
      if block_given?
        return true if yield re
      elsif block.instance_of?(Regexp)
        return true if block =~ re
      elsif block.instance_of?(Class)
        return true if [re.class, re.class.superclass].include?(block)
      elsif !block.nil?
        return true if re == block
      else
        return true unless re
      end
    end
    return true if block.nil? && !block_given?

    false
  end

  def my_none?(block = nil)
    return true if (self - [nil, false]) == []

    my_each_with_index do |re, i|
      if block_given?
        return false if yield re
      elsif block.instance_of?(Class)
        return false if [re.class, re.class.superclass].include?(block)
      elsif block.instance_of?(Regexp)
        return false if block =~ re
      elsif !block.nil?
        return false if re == block
      elsif i.positive? && self[i] != self[i - 1]
        return false
      end
    end
    true
  end

  def my_count(block = nil)
    nu = 0
    if block_given?
      my_each { |i| nu += 1 if yield(i) }
    elsif !block.nil?
      my_each { |i| nu += 1 if i == nu }
    else
      return size
    end
    nu
  end

  def my_map(block = nil)
    arr1 = []
    arr2 = []
    x = 0
    arr2 = if respond_to?(:to_ary)
             self
           else
             to_a
           end
    if !block.nil?
      arr2.length.times do
        arr1.push(block.call(arr2[x]))
        x += 1
      end
    else
      arr2.length.times do
        arr1.push(yield(arr2[x]))
        x += 1
      end
    end
    arr1
  end

  def my_inject(arg = nil, sym = nil)
    if (arg.is_a?(String) || arg.is_a?(Symbol)) && (!arg.nil? && sym.nil?)
      sym = arg
      arg = nil
    end

    if !block_given? && !sym.nil?
      my_each { |s| arg = arg.nil? ? s : arg.send(sym, s) }
    else
      my_each { |s| arg = arg.nil? ? s : yield(arg, s) }
    end
    arg
  end
end

def multiply_els(arr)
  arr.my_inject { |x, y| x * y }
end


puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
puts %w{ant bear cat}.my_none?(/d/)                        #=> true
puts [1, 3.14, 42].my_none?(Float)                         #=> false
puts [].my_none?                                           #=> true
puts [nil].my_none?                                        #=> true
puts [nil, false].my_none?                                 #=> true
puts [nil, false, true].my_none?                           #=> false