class FiltersGrid < Netzke::Basepack::GridPanel

  js_configure do |c|
    c.mixin :main
  end

  action :add_in_form do |a|
    a.icon    = :script_add
    a.text    = "Add"
    a.tooltip = "Add filter"
  end

  action :edit_in_form do |a|
    a.icon      = :script_edit
    a.text      = "Edit"
    a.tooltip   = "Edit filter"
    a.disabled  = false
  end

  action :del do |a|
    a.icon = :script_delete
  end

  def configure(c)
    column_defaults                 = Hash.new
    column_defaults[:editable]      = false
    column_defaults[:sortable]      = false
    column_defaults[:menu_disabled] = true
    column_defaults[:resizable]     = false
    column_defaults[:draggable]     = false
    column_defaults[:fixed]         = true

    form_window_config              = Hash.new
    form_window_config[:y]          = 100
    form_window_config[:width]      = 700
    form_window_config[:height]     = 500

    super
    c.name             = :filters_grid
    c.title            = "Filters"
    c.model            = "Filter"
    c.border           = false
    c.context_menu     = [:edit_in_form.action, :del.action]
    c.tbar             = [:add_in_form.action]
    c.bbar             = []
    c.tools            = false
    c.multi_select     = false
    c.prohibit_update  = true
    c.columns          = [
      column_defaults.merge(:name => :name,               :text => "Name",          :flex => true),
      column_defaults.merge(:name => :interpreter,        :text => "Interpreter",   :editor => {:xtype => :netzkeremotecombo, :editable => false}),
      column_defaults.merge(:name => :code,               :text => "Code",          :hidden => true, :editor => {:height => 350, :field_cls => 'code-editor'})
    ],
      :add_form_window_config   => form_window_config.merge(:title => "Add scriptable filter"),
      :edit_form_window_config  => form_window_config.merge(:title => "Edit scriptable filter")
  end

  def get_combobox_options(params)
    case params[:column]
      when "interpreter"
        return { :data => INTERPRETERS.collect {|i| [i, i]} }
    end
    super
  end

  endpoint :add_form__netzke_0__get_combobox_options do |params, this|
    this.netzke_set_result(get_combobox_options(params))
  end

  endpoint :edit_form__netzke_0__get_combobox_options do |params, this|
    this.netzke_set_result(get_combobox_options(params))
  end

end
