class ProfileController < UIViewController
  attr_accessor :username

  def viewDidLoad
    super
    @settings_controller = SettingsController.alloc.initController
    @settings_controller.form.render
    view.backgroundColor = UIColor.whiteColor
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Settings", style:UIBarButtonItemStyleBordered, target:self, action:'open_setting')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Search", style:UIBarButtonItemStyleDone, target:self, action:'open_search')
  end

  def viewWillAppear(animated)
    settings = @settings_controller.form.render
    username = settings[:username]
    password = settings[:password]

    App.delegate.login(username, password) do |res|
      if res
        if @username.nil?
          load_self
        else
          load_user(@username)
        end
      else
        open_setting
      end
    end
  end

  def open_search
    p 'open_search'
  end

  def open_setting
    @settings_controller.delegate = self
    settings_nav = UINavigationController.alloc.initWithRootViewController(@settings_controller)
    presentModalViewController(settings_nav, animated:true)
  end

  def close_setting(setting)
    setting.delegate = nil
    dismissModalViewControllerAnimated(true)
  end

  def load_self
    p 'load_self'
  end

  def load_user(username)
    p 'load_user'
  end
end