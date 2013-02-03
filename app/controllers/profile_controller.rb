class ProfileController < UIViewController
  attr_accessor :username

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    view.addSubview(profile_view)
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction, target:self, action:'open_action')
  end

  def profile_view
    @profile_view ||= ProfileView.alloc.initWithFrame(content_frame)
  end

  def open_action
    p 'open_action'
  end

  def viewWillAppear(animated)
    profile_view.deselectRowAtIndexPath(profile_view.indexPathForSelectedRow, animated:true)
    fetch_user(@username)
  end

  def viewDidAppear(animated)
    profile_view.flashScrollIndicators
  end

  def fetch_user(username)
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
    User.fetch_user(username)
  end

  def display_user(user)
    profile_view.user = user
  end

end