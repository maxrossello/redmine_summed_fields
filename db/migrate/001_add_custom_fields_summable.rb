class AddCustomFieldsSummable < ActiveRecord::Migration

    def self.up
        add_column :custom_fields, :summable, :boolean, :default => false, :null => false
    end

    def self.down
        remove_column :custom_fields, :summable
    end

end
