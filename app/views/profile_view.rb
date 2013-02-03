class ProfileView < UITableView
  include BW::KVO
  attr_accessor :user

  @@cells = [
    :main,
    :blog,
    :url,
    :followers,
    :following
  ]

  def initWithFrame(rect, style:style)
    super.tap do
      self.delegate = self.dataSource = self
      observe(self, :user) do |old_user, new_user|
        self.reloadData if old_user != new_user
      end
      self.user = User.new
      self.styleId = 'profile'
    end
  end

  def dealloc
    unobserve_all
    super
  end

  def numberOfSectionsInTableView(table_view)
    1
  end

  def tableView(table_view, numberOfRowsInSection:section)
    @@cells.count
  end

  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell_id = @@cells[index_path.row]
    if cell_id == :main
      90
    else
      60
    end
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell_id = @@cells[index_path.row]
    case cell_id
    when :main
      cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:cell_id)
      cell.textLabel.text = @user.login
      cell.detailTextLabel.text = @user.location
      Dispatch::Queue.concurrent.async {
        data = NSData.dataWithContentsOfURL(NSURL.URLWithString(@user.avatar_url))
        image = UIImage.imageWithData(data)
        Dispatch::Queue.main.async {
          cell.imageView.image = image
          cell.setNeedsLayout
        }
      }
    when :blog
      cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_id)
      cell.textLabel.text = @user.blog
    when :url
      cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_id)
      cell.textLabel.text = @user.html_url
    when :followers
      cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_id)
      cell.textLabel.text = "#{@user.followers} Followers"
    when :following
      cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_id)
      cell.textLabel.text = "#{@user.following} Following"
    end
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    cell_id = @@cells[index_path.row]
    p cell_id
  end

end