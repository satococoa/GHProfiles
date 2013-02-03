class SearchController < UIViewController
  include BW::KVO
  attr_accessor :myself

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    observe(self, :myself) do |old_value, new_value|
      p new_value if old_value != new_value
    end
  end

  def dealloc
    unobserve_all
    super
  end
end