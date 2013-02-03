class Github
  attr_reader :engine

  def self.shared
    Dispatch.once {
      @instance = new
    }
    @instance
  end

  def setup(username, password)
    @engine = UAGithubEngine.alloc.initWithUsername(username, password:password, withReachability:true)
  end

  def self.api
    @instance.engine
  end
end