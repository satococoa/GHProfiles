class SettingsController < Formotion::FormController
  attr_accessor :delegate

  @@settings_hash = {
    title: 'Setting',
    persist_as: :settings,
    sections: [{
      rows: [
        {
          title: 'Username',
          type: :string,
          key: :username,
          value: '',
          auto_correction: :no,
          auto_capitalization: :none
        },
        {
          title: 'Password',
          type: :string,
          key: :password,
          secure: true,
          auto_correction: :no,
          auto_capitalization: :none
        }
      ]
    }]
  }

  def initController
    f = Formotion::Form.persist(@@settings_hash)
    initWithForm(f)
  end

  def viewDidLoad
    super
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Done", style:UIBarButtonItemStyleDone, target:self, action:'done')
  end

  def done
    @delegate.close_setting(self)
  end
end