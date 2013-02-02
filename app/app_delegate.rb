class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
  end

  def github
    Dispatch.once {
      # TODO: あとでユーザ名とパスワードを入力されたものを使う
      @github = UAGithubEngine.alloc.initWithUsername('username', password:'password', withReachability:true)
    }
    @github
  end
end
