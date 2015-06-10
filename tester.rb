require 'open-uri'

class AdblockTester
  attr_reader :matched_lists

  def initialize(url)
    @url = url
    @matched_lists = parse_lists(get_lists)
  end

  def get_lists
    lists = []

    open(@url) do |res|
      res.each_line do |line|
        # grossness to follow
        if list = /http(s):\/\/(.*)\.txt/.match(line)
          if !@list.to_s.index('&')
            lists.push list.to_s
          end
        end
      end
    end

    lists.uniq
  end

  def parse_lists(lists)
    matched_lists = []

    lists.each do |list|
      begin
        open(list) do |res|
          res.each_line do |line|
            if /#{ARGV[0]}/.match(line)
              matched_lists.push list
            end
          end
        end
      rescue
        # do nothing for lists that can't be opened
      end
    end

    matched_lists.uniq
  end
end

# Start
puts "Checking if #{ARGV[0].capitalize} is on any adblock lists\nThis may take a few minutes..."

tester = AdblockTester.new("https://easylist.adblockplus.org/en/")

if tester.matched_lists.size > 0
  puts "Found #{ARGV[0]} on the following #{tester.matched_lists.size} list(s)"
  puts tester.matched_lists
else
  puts "#{ARGV[0].capitalize} is not on any adblock lists, rejoice!"
end