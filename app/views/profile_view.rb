class ProfileView < UITableView
  include BW::KVO
  attr_accessor :user

  def initWithFrame(rect, style:style)
    super.tap do
      self.delegate = self.dataSource = self
      observe(self, :user) do |old_user, new_user|
        self.reloadData if old_user != new_user
      end
      self.user = User.new
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
    @user.instance_variables.count
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell_id = 'cell'
    cell = table_view.dequeueReusableCellWithIdentifier(cell_id) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue2, reuseIdentifier:cell_id)
    cell.textLabel.text = @user.instance_variables[index_path.row]
    cell.detailTextLabel.text = @user.instance_variable_get(@user.instance_variables[index_path.row]).to_s
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    p index_path
  end

end