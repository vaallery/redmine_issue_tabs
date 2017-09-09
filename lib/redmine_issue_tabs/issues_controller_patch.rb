module RedmineIssueTabs
  module IssuesControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        before_filter :get_time_entries, only: [:show]
      end
    end

    module InstanceMethods
      def get_time_entries
        @time_entries = @issue.time_entries.preload(:user, :activity).order("#{TimeEntry.table_name}.spent_on DESC")
        unless User.current.allowed_to?(:view_all_time_entries_in_issue, @project)
          @time_entries = @time_entries.where(user_id: User.current.id)
        end
      end
    end
  end
end
