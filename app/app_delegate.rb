class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @myprofile_controller = MyProfileController.new

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@myprofile_controller)

    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible
    true
  end
end
