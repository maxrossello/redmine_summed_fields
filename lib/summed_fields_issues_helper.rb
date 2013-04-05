require_dependency 'issues_helper'

module SummedFieldsIssuesHelper
    
    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :render_descendants_tree, :summed
      end
    end

    module InstanceMethods

      def render_descendants_tree_with_summed(issue)
        custom_fields = issue.available_custom_fields
        s = '<form><table class="list issues">'
        field_header = ''
        custom_fields.each do |field|
          if field.summable?
            field_header << content_tag('th', field.name)
          end
        end
        s << content_tag('tr',
          content_tag('th', l(:field_subject)) +
          content_tag('th', l(:field_status)) +
          content_tag('th', l(:field_assigned_to)) +
          field_header)
        issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|
          field_values = ''
          custom_fields.each do |field|
            if field.summable?
              found = false
              child.custom_field_values.each do |cv|
                if field.name == cv.custom_field.name
                  found = true
                  field_values << content_tag('td align="right"', cv.value)
                end
              end
              field_values << content_tag('td', '') unless found
            end
          end
          s << content_tag('tr',
             content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
             content_tag('td', link_to_issue(child, :truncate => 60), :class => 'subject') +
             content_tag('td align="center"', h(child.status)) +
             content_tag('td align="center"', link_to_user(child.assigned_to)) +
             field_values)
             #content_tag('td', progress_bar(child.done_ratio, :width => '80px')),
             #:class => "issue issue-#{child.id} hascontextmenu #{level > 0 ? "idnt idnt-#{level}" : nil}")
        end
        s << '</table></form>'
        s.html_safe
      end

    end
end

