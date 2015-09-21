module PublicActivity
  module ORM
    module ActiveRecord
      # The ActiveRecord model containing
      # details about recorded activity.
      class Activity < ::ActiveRecord::Base
        include Renderable
        self.table_name = PublicActivity.config.table_name

        # Define polymorphic association to the parent
        belongs_to :trackable, lambda { |record| record.respond_to?(:with_deleted) ? with_deleted : record }, :polymorphic => true
        # Define ownership to a resource responsible for this activity
        belongs_to :owner, lambda { |record| record.respond_to?(:with_deleted) ? with_deleted : record }, :polymorphic => true
        # Define ownership to a resource targeted by this activity
        belongs_to :recipient, lambda { |record| record.respond_to?(:with_deleted) ? with_deleted : record }, :polymorphic => true
        # Serialize parameters Hash
        serialize :parameters, Hash

        if ::ActiveRecord::VERSION::MAJOR < 4 || defined?(ProtectedAttributes)
          attr_accessible :key, :owner, :parameters, :recipient, :trackable
        end
      end
    end
  end
end
