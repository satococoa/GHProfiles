class MyProfileController < UIViewController
  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    view.addSubview(profile_view)
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style:UIBarButtonItemStyleBordered, target:self, action:'confirm_logout')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Search", style:UIBarButtonItemStyleDone, target:self, action:'open_search')
  end

  def profile_view
    @profile_view ||= ProfileView.alloc.initWithFrame(content_frame)
  end

  def settings_controller
    @settings_controller ||= SettingsController.alloc.initController.tap do |c|
      c.delegate = self
    end
  end

  def open_settings
    presentViewController(settings_controller, animated:true,
      completion:lambda {})
  end

  def submit_settings(data)
    dismissViewControllerAnimated(true,
      completion:lambda {
        Github.shared.setup(data[:username], data[:password])
        fetch_myprofile
      }
    )
  end

  def viewWillAppear(animated)
    profile_view.deselectRowAtIndexPath(profile_view.indexPathForSelectedRow, animated:true)
    Dispatch.once {
      data = settings_controller.form.render
      if data[:username].nil? || data[:password].nil? ||
        data[:username] == '' || data[:password] == ''
        open_settings
      else
        Github.shared.setup(data[:username], data[:password])
        fetch_myprofile
      end
    }
  end

  def viewDidAppear(animated)
    profile_view.flashScrollIndicators
  end

  def fetch_myprofile
    observer = App.notification_center.observe('UserFetched') do |notif|
      p '============= OBSERVER =============='
      p notif.userInfo
      if notif.userInfo[:error].nil?
        p "User: #{notif.userInfo[:user]}"
        @myself = notif.userInfo[:user]
        display_user(@myself)
      else
        open_settings
      end
      App.notification_center.unobserve(observer)
    end
    User.fetch_myself
  end

  def display_user(user)
    navigationItem.title = user.login
    profile_view.user = user
  end

  def confirm_logout
    alert = UIAlertView.alloc.initWithTitle('Logout', message:'Are you sure to logout?', delegate:self, cancelButtonTitle:'Cancel', otherButtonTitles:'Yes', nil)
    alert.show
  end

  def alertView(alert_view, clickedButtonAtIndex:button_index)
    return if button_index == alert_view.cancelButtonIndex
    logout
  end

  def logout
    settings_controller.form.reset
    open_settings
  end

  def open_search
    search_controller = SearchController.new
    search_controller.myself = @myself
    navigationController.pushViewController(search_controller, animated:true)
  end
end