require 'redmine'

Rails.logger.info 'Starting Summable Fields plugin for Redmine'

require_dependency 'summed_fields_hook'
require_dependency 'summed_fields_issues_helper'

Rails.configuration.to_prepare do
  unless Issue.included_modules.include?(SummedFieldsIssuePatch)
      Issue.send(:include, SummedFieldsIssuePatch)
  end

  unless IssuesHelper.included_modules.include?(SummedFieldsIssuesHelper)
      IssuesHelper.send(:include, SummedFieldsIssuesHelper)
  end
end

Redmine::Plugin.register :redmine_summed_fields do
  name 'Summed Fields'
  author 'Massimo Rossello'
  description 'Allows for numeric issue custom fields to be summed up in the parent task similar to effort estimates and spent time'
  version '1.0.1'
  url 'https://github.com/maxrossello/redmine_summed_fields.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '1.4.0'

  settings(:default => {
              'progress_bar' => false,
           },
           :partial => 'summed_fields/settings'
  )
end
