require_dependency 'issues_helper'

module SummedFieldsIssuesHelper
    
    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :render_descendants_tree, :listed
      end
    end

    module InstanceMethods

      def render_descendants_tree_with_listed(issue)
        field_values = ''
        field_headers = ''
        map = []
        s = '<form><table class="list issues">'

        issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|
          custom_fields = child.available_custom_fields
          custom_fields.each do |field|
            if field.listed? and map.find_index(field.name).nil?
              field_headers << content_tag('th', field.name)
              map << field.name
            end
          end
        end
        s << content_tag('tr',
          content_tag('th', l(:field_subject)) +
          content_tag('th', l(:field_status)) +
          content_tag('th', l(:field_assigned_to)) +
          field_headers.html_safe)

        issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|
          custom_fields = child.available_custom_fields
          css = "issue issue-#{child.id} hascontextmenu"
          css << " idnt idnt-#{level}" if level > 0
          field_content = #<< #content_tag('tr',
             content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
             content_tag('td', link_to_issue(child, :truncate => 60), :class => 'subject') +
             content_tag('td align="center"', h(child.status)) +
             content_tag('td align="center"', link_to_user(child.assigned_to))
             #content_tag('td', progress_bar(child.done_ratio, :width => '80px')),
             #:class => "issue issue-#{child.id} hascontextmenu #{level > 0 ? "idnt idnt-#{level}" : nil}")

          map.each do |field|
            found = false
            child.custom_field_values.each do |cv|
              if field == cv.custom_field.name
                found = true
                field_content << content_tag('td align="right"', cv.value)
              end
            end
            field_content << content_tag('td bgcolor="#dddddd" class="no-field-owner"', '') unless found
          end
          field_values << content_tag('tr', field_content, :class => css).html_safe
        end
        s << field_values
        s << '</table></form>'
        s.html_safe
      end

    end
end

