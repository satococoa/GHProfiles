class ProfileController < UIViewController
  attr_accessor :username, :myself

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
    if @myself.following?(username)
      action_sheet = UIActionSheet.alloc.initWithTitle('Follow', delegate:self, cancelButtonTitle:'Cancel', destructiveButtonTitle:'Unfollow', otherButtonTitles:nil)
    else
      action_sheet = UIActionSheet.alloc.initWithTitle('Follow', delegate:self, cancelButtonTitle:'Cancel', destructiveButtonTitle:nil, otherButtonTitles:'Follow', nil)
    end
    action_sheet.showInView(view)
  end

  def actionSheet(sheet, clickedButtonAtIndex:button_index)
    p button_index
  end

  def viewWillAppear(animated)
    profile_view.deselectRowAtIndexPath(profile_view.indexPathForSelectedRow, animated:true)
    fetch_user(@username)
    @open_url_observer = App.notification_center.observe('URLTapped') do |notif|
      url = notif.userInfo[:url]
      open_url(url)
    end
  end

  def viewDidAppear(animated)
    profile_view.flashScrollIndicators
  end

  def viewWillDisappear(animated)
    App.notification_center.unobserve(@open_url_observer)
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
    navigationItem.title = user.login
    profile_view.user = user
  end

  def open_url(url)
    webview_controller = SVWebViewController.alloc.initWithAddress(url)
    navigationController.pushViewController(webview_controller, animated:true)
  end

end