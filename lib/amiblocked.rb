class AmIBlocked
  def initialize(config = {})
    Notify.error("A URL is required") if config[:url].nil?
    Notify.error("A service name is required, e.g.\namiblocked doubleclick") if config[:service].nil?

    @url = config[:url]
    
    execute_and_report(config)
  end

  private

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

  def execute_and_report(config)
    Notify.info("Checking if #{config[:service]} is on any adblock lists\nThis may take a few minutes...")

    matched_lists = parse_lists(get_lists)
    
    if matched_lists.size > 0
      Notify.warning("Found #{config[:service]} on #{matched_lists.size} lists")
      Notify.warning(matched_lists.join("\n"))
    else
      Notify.success("#{config[:service].capitalize} was not found on any lists, rejoice!")
    end
  end
end