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
        },
      ]
    },
    {
      rows: [
        {
          title: 'Login',
          type: :submit
        }
      ]
    }]
  }

  def initController
    f = Formotion::Form.persist(@@settings_hash)
    f.on_submit do |fm|
      @delegate.submit_settings(fm.render)
    end
    initWithForm(f)
  end
end