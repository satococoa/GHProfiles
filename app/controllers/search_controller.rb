class SearchController < UIViewController
  attr_accessor :myself

  def viewDidLoad
    super
    navigationItem.title = 'Search'
    view.styleId = 'search'
    view.backgroundColor = UIColor.whiteColor
    @qrcode_view = LoadableImageView.new.tap do |v|
      v.frame = [[60, 10], [200, 200]]
      v.loading = true
    end
    view.addSubview(@qrcode_view)

    @read_button = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
      b.setTitle('Read', forState:UIControlStateNormal)
      b.addTarget(self, action:'open_reader', forControlEvents:UIControlEventTouchUpInside)
      b.frame = [[10, 220], [300, 60]]
      b.styleId = 'read-button'
    end
    view.addSubview(@read_button)

    @debug = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
      b.setTitle('[Debug]', forState:UIControlStateNormal)
      b.addTarget(self, action:'debug', forControlEvents:UIControlEventTouchUpInside)
      b.frame = [[10, 300], [300, 60]]
    end
    view.addSubview(@debug)
  end

  def debug
    open_profile('naoty')
  end

  def viewWillAppear(animated)
    display_qrcode(@myself)
  end

  def display_qrcode(user)
    str = "ghprofiles://#{user.login}"
    image = QREncoder.encode(str)
    @qrcode_view.loading = false
    @qrcode_view.image = image
  end

  def open_reader
    p 'open_reader'
    reader = ZBarReaderViewController.new.tap do |r|
      r.readerDelegate = self;
    end
    self.presentModalViewController(reader, animated:true)
  end

  def imagePickerController(reader, didFinishPickingMediaWithInfo:info)
    results = info[ZBarReaderControllerResults]
    url = ''
    results.each do |symbol|
      url = symbol.data
    end
    reader.dismissModalViewControllerAnimated(true)
    if matched = url.match(%r!^ghprofiles://(.+)$!)
      open_profile(matched[1])
    else
      App.error('Scan error!')
    end
  end

  def open_profile(username)
    profile_controller = ProfileController.new
    profile_controller.username = username
    profile_controller.myself = @myself
    navigationController.pushViewController(profile_controller, animated:true)
  end
end