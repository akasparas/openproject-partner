# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject
  module Partner
    class Engine < ::Rails::Engine
      engine_name :openproject_partner

      include OpenProject::Plugins::ActsAsOpEngine

      class << self
        def settings
          {
            partial: 'settings/partner',
            default: {

            }
          }
        end
      end

      register( 'openproject-partner',
              :author_url => 'https://openproject.org',
              :requires_openproject => '>= 6.0.0',
              settings: settings
      ) do
        
        menu :admin_menu,
            :partner,
            {
              controller: 'partners' #,
              #action: 'plugin',
              #id: 'openproject_partner'
            },
            caption: 'Partners',
            icon: 'icon2 icon-backlogs'

      end

      patches [
        :Project,
        :ProjectsHelper
      ]
      
      assets %w(project/partner_attribute.js)

    end
  end
end
