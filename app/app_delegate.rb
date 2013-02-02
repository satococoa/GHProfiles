class AppDelegate
  attr_reader :github

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)

    profile_controller = ProfileController.new

    navigation_controller = UINavigationController.alloc.initWithRootViewController(profile_controller)

    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible
    true
  end

  def login(username, password, &block)
    @github = UAGithubEngine.alloc.initWithUsername(username, password:password, withReachability:true)
    @github.userWithSuccess(
      lambda {|res|
        block.call(true)
      },
      failure:lambda {|err|
        p [err.code, err.domain].join(', ') + err.userInfo.inspect
        block.call(false)
      }
    )
  end
end
