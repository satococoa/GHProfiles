module UnobtrusiveAlert
  def show_loading
    SVProgressHUD.show
  end

  def hide_loading
    SVProgressHUD.dismiss
  end

  def success(message)
    SVProgressHUD.showSuccessWithStatus(message)
  end

  def error(message)
    SVProgressHUD.showErrorWithStatus(message)
  end
end
App.extend(UnobtrusiveAlert)