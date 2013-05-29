class AddSubtaskVisibleField < ActiveRecord::Migration

    def self.up
        add_column :custom_fields, :listed, :boolean, :default => false, :null => false
    end

    def self.down
        remove_column :custom_fields, :listed
    end

end
