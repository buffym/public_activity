module PublicActivity
  module ORM
    module ActiveRecord
      # The ActiveRecord model containing
      # details about recorded activity.
      class Activity < ::ActiveRecord::Base
        include Renderable
        self.table_name = PublicActivity.config.table_name

        # Define polymorphic association to the parent
        belongs_to :trackable, :polymorphic => true
        # Define ownership to a resource responsible for this activity
        belongs_to :owner, :polymorphic => true
        # Define ownership to a resource targeted by this activity
        belongs_to :recipient, :polymorphic => true
        # Serialize parameters Hash
        serialize :parameters, Hash

        if ::ActiveRecord::VERSION::MAJOR < 4 || defined?(ProtectedAttributes)
          attr_accessible :key, :owner, :parameters, :recipient, :trackable
        end

        def unscoped_trackable
          unless @unscoped_trackable
            klazz = self.trackable_type.constantize
            if klazz.respond_to?(:with_deleted)
              @unscoped_trackable = klazz.with_deleted.where(id: self.trackable_id).first
            else
              @unscoped_trackable = self.trackable
            end
          end
          @unscoped_trackable
        end

        def unscoped_recipient
          unless @unscoped_recipient
            klazz = self.recipient_type.constantize
            if klazz.respond_to?(:with_deleted)
              @unscoped_recipient = klazz.with_deleted.where(id: self.recipient_id).first
            else
              @unscoped_recipient = self.recipient
            end
          end
          @unscoped_recipient
        end

        def unscoped_owner
          unless @unscoped_owner
            klazz = self.owner_type.constantize
            if klazz.respond_to?(:with_deleted)
              @unscoped_owner = klazz.with_deleted.where(id: self.owner_id).first
            else
              @unscoped_owner = self.owner
            end
          end
          @unscoped_owner
        end

      end
    end
  end
end
