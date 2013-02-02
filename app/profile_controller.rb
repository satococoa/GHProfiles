class ProfileController < UIViewController
  attr_accessor :username

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style:UIBarButtonItemStyleBordered, target:self, action:'confirm_logout')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Search", style:UIBarButtonItemStyleDone, target:self, action:'open_search')
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
    App.delegate.logout
  end

  def open_search
    p 'open_search'
  end

  def load_self
    App.delegate.github.userWithSuccess(
      lambda {|res|
        p res
      },
      failure:lambda {|err|
        p err
      }
    )
  end

  def load_user(username)
    App.delegate.github.user(username,
      success:lambda {|res|
        p res
      },
      failure:lambda {|err|
        p err
      }
    )
  end
end