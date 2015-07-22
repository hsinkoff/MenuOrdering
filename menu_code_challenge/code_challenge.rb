class FindAppsToOrder
  attr_reader :file

  def initialize(file)
    @file = file
    @appetizer_prices = []
    @appetizers = {}
    @message = []
  end

  def read_file
    @opened_file = File.open(file, "r")
    @total_price = @opened_file.readline.slice!(1..-1).to_f
    @opened_file.each_line do |line|
      @menu = line.split(',')
      @appetizers[@menu[1].slice(1..-1).to_f] = @menu[0]
      @appetizer_prices << @menu[1].slice(1..-1).to_f
    end
  end

  def find_combos(app_prices, cost, partial = [0])
    sum = partial.inject {|sum, n| sum + n}
    if sum == cost
      @message << partial
      return
    end
    return if sum >= cost
    if @message.empty?
      app_prices.each_index do |i|
        item = app_prices[i]
        remaining_items = app_prices.drop(i+1)
        find_combos(remaining_items, cost, partial + [item])
      end
    end
  end

  def print_message
    if @message.empty?
      puts "Sorry, there is no combination of dishes that will equal the target price."
    else
      @message[0].shift
      @message[0].each_index do |i|
        puts @appetizers[@message[0][i]]
      end
    end
  end

  def find_order
    self.read_file
    self.find_combos(@appetizer_prices, @total_price)
    self.print_message
  end
end


@file = ARGV.first
@order = FindAppsToOrder.new(@file)
@order.find_order