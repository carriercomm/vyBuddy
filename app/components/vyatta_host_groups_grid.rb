class VyattaHostGroupsGrid < Netzke::Basepack::GridPanel

  js_mixin :init_component
  js_mixin :methods

  action :add_in_form,  :text => "Add",  :tooltip => "Add task group"
  action :edit_in_form, :text => "Edit", :tooltip => "Edit task group", :disabled => false

  def configuration
    column_defaults                 = Hash.new
    column_defaults[:editable]      = false
    column_defaults[:sortable]      = false
    column_defaults[:menu_disabled] = true
    column_defaults[:resizable]     = false
    column_defaults[:draggable]     = false
    column_defaults[:fixed]         = true

    form_window_config              = Hash.new
    form_window_config[:y]          = 100
    form_window_config[:width]      = 500

    super.merge(
      :name             => :vyatta_host_groups_grid,
      :title            => "Host groups",
      :model            => "VyattaHostGroup",
      :load_inline_data => false,
      :border           => false,
      :context_menu     => [:edit_in_form.action, :del.action],
      :tbar             => [:add_in_form.action],
      :bbar             => [],
      :tools            => false,
      :multi_select     => false,
      :prohibit_update  => true,
      :view_config      => {
        :plugins => [ { :ptype => :gridviewdragdrop, :drag_group => :vyatta_host_groups_dd_group, :drop_group => :vyatta_host_groups_dd_group, :drag_text => "Drag and drop to reorganize" } ]
      },
      :columns          => [
        column_defaults.merge(:name => :name,                     :text => "Name",            :flex => true),
        column_defaults.merge(:name => :sort_order,               :text => "#",               :width => 40, :align => :center, :editor => {:hidden => true}),
        column_defaults.merge(:name => :is_enabled,               :text => "Enabled?",        :hidden => true)
      ],
      :add_form_window_config   => form_window_config,
      :edit_form_window_config  => form_window_config
    )
  end

  endpoint :reorganize_with_persistent_order do |params|
    moved_vyatta_host_group     = VyattaHostGroup.find(params[:moved_record_id].to_i)
    replaced_vyatta_host_group  = VyattaHostGroup.find(params[:replaced_record_id].to_i)
    position                    = params[:position].to_sym
    success                     = VyattaHostGroup.reorganize_with_persistent_order(moved_vyatta_host_group, replaced_vyatta_host_group, position)
    return { :set_result => { :success => success, :message => VyattaHostGroup.reorganize_with_persistent_order_message } }
  end

  endpoint :delete_data do |params|
    if !config[:prohibit_delete]
      record_ids = ActiveSupport::JSON.decode(params[:records])
      data_class.destroy(record_ids)
      on_data_changed
      {:netzke_feedback => I18n.t('netzke.basepack.grid_panel.deleted_n_records', :n => record_ids.size), :after_delete => get_data}
    else
      {:netzke_feedback => I18n.t('netzke.basepack.grid_panel.cannot_delete')}
    end
  end

  endpoint :reorder_records do |params|
    records           = VyattaHostGroup.all
    reordered_records = VyattaHostGroup.reorder_records(records)
    success           = !reordered_records.nil? and !reordered_records.empty? ? true : false
    message           = VyattaHostGroup.reorder_records_message
    { :set_result => { :success => success, :message => message } }
  end

end