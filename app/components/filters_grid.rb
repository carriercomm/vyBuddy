class FiltersGrid < Netzke::Basepack::GridPanel

  action :add_in_form,  :text => "Add",  :tooltip => "Add filter"
  action :edit_in_form, :text => "Edit", :tooltip => "Edit filter"

  def configuration
    column_defaults                 = Hash.new
    column_defaults[:editable]      = false
    column_defaults[:sortable]      = false
    column_defaults[:menu_disabled] = true
    column_defaults[:resizable]     = false
    column_defaults[:draggable]     = false
    column_defaults[:fixed]         = true

    super.merge(
      :name             => :filters_grid,
      :title            => "Filters",
      :model            => "Filter",
      :scope            => lambda { |s| s.sorted },
      :border           => false,
      :context_menu     => [:edit_in_form.action, :del.action],
      :tbar             => [:add_in_form.action],
      :bbar             => [],
      :tools            => false,
      :multi_select     => false,
      :columns          => [
        column_defaults.merge(:name => :name,               :text => "Name",          :flex => true),
        column_defaults.merge(:name => :interpreter,        :text => "Interpreter"),
        column_defaults.merge(:name => :code,               :text => "Code",          :hidden => true)
      ]
    )
  end

end
