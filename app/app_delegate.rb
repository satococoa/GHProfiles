class AppDelegate
  attr_reader :github

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)

    profile_controller = ProfileController.new

    navigation_controller = UINavigationController.alloc.initWithRootViewController(profile_controller)

    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible

    data = settings_controller.form.render
    login(data[:username], data[:password]) do |res|
      open_settings unless res
    end

    true
  end

  def settings_controller
    @settings_controller ||= SettingsController.alloc.initController
  end

  def open_settings
    @window.rootViewController.presentModalViewController(settings_controller, animated:true)
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

  def logout
    @github = nil
    settings_controller.form.reset
    open_settings
  end
end
