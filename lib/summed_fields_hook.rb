class SummedFieldsHook  < Redmine::Hook::ViewListener
  render_on :view_custom_fields_form_issue_custom_field, :partial => 'custom_fields/summable'
end

