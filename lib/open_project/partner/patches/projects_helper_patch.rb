module OpenProject
  module Partner
    module Patches
      module ProjectsHelperPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            alias_method :project_settings_tabs_without_partners, :project_settings_tabs

            def project_settings_tabs
              project_settings_tabs_without_partners.tap do |settings|
                settings << {
                  name: 'partner_settings',
                  action: :manage_project_partner,
                  partial: 'projects/settings/partner_settings',
                  label: 'partner.partner_settings'
                }
              end
            end
      
          end
        end
      end
    end
  end
end
