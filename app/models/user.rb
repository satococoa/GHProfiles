class User
  attr_accessor :login, :html_url, :blog, :location,
    :followers_url, :followers, :folloing_url, :following, :avatar_url

  def initialize(hash = {})
    @login         = hash['login']
    @html_url      = hash['html_url']
    @blog          = hash['blog']
    @location      = hash['location']
    @followers_url = hash['followers_url']
    @followers     = hash['followers']
    @following_url = hash['following_url']
    @following     = hash['following']
    @avatar_url    = hash['avatar_url']
  end

  class << self
    def fetch_myself
      Github.api.userWithSuccess(
        lambda {|res|
          fetch_success(res)
        },
        failure:lambda {|err|
          fetch_failure(err)
        }
      )
    end

    def fetch_user(username)  
      Github.api.user(username,
        success:lambda {|res|
          fetch_success(res)
        },
        failure:lambda {|err|
          fetch_failure(err)
        }
      )
    end

    def fetch_success(result)
      p 'fetch_success'
      user_info = {user: new(result[0])}
      App.notification_center.post('UserFetched', self, user_info)
    end

    def fetch_failure(error)
      p 'fetch_failure'
      p [error.code, error.domain].join(', ') + error.userInfo.inspect
      user_info = {user: nil, error: error}
      App.notification_center.post('UserFetched', self, user_info)
    end
  end
end