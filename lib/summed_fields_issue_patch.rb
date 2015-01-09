require_dependency 'issue'

module SummedFieldsIssuePatch
    
    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :safe_attributes=, :summed
            alias_method_chain :recalculate_attributes_for, :summed
      end
    end

    module InstanceMethods
        def safe_attributes_with_summed=(attrs, user=User.current)
          unless leaf? or attrs.nil?
            if attrs['summable']
              attrs.delete('summable')
            end
            if attrs['listed']
              attrs.delete('listed')
            end
          end
          send :safe_attributes_without_summed=, attrs, user
        end

        def recalculate_attributes_for_with_summed(issue_id)
          if issue_id && p = Issue.find_by_id(issue_id)
            custom_fields = p.available_custom_fields
            custom_fields.each do |field|
              if field.summable? 
                p.custom_field_values.each do |v|
                  if field.name == v.custom_field.name
                    v.value = 0
                    p.leaves.each do |leave|
                      leave.custom_field_values.each do |lv|
                        if field.name == lv.custom_field.name
                          case field.field_format
                          when 'float'
                              v.value += lv.value.to_f
                          else
                              v.value += lv.value.to_i
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            p.save_custom_field_values
          end
          recalculate_attributes_for_without_summed(issue_id)
        end
    end

end

