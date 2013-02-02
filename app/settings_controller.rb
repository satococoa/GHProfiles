class SettingsController < Formotion::FormController
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
      challenge(fm)
    end
    initWithForm(f)
  end

  def challenge(submitted_form)
    App.show_loading
    data = submitted_form.render
    username = data[:username]
    password = data[:password]
    App.delegate.login(username, password) do |res|
      if res
        self.form.save
        dismissModalViewControllerAnimated(true)
      else
        App.error('Login failed...')
      end
    end
  end
end