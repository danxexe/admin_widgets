module AdminWidgets
  class Engine < Rails::Engine
    config.to_prepare do
      require_dependency 'admin_widgets/helper'
      require_dependency 'admin_widgets/memoization'
      require_dependency 'admin_widgets/delegation'
      require_dependency 'admin_widgets/base_widget'
      require_dependency 'admin_widgets/base_form_widget'
      require_dependency 'admin_widgets/form_widget'
      require_dependency 'admin_widgets/form/fieldset_widget'
      require_dependency 'admin_widgets/wizard_widget'
      require_dependency 'admin_widgets/list_widget'
      require_dependency 'admin_widgets/scopes_widget'
      require_dependency 'admin_widgets/filters_widget'
      require_dependency 'admin_widgets/show_widget'
      require_dependency 'admin_widgets/show/fieldset_widget'

      ActionView::Base.send :include, AdminWidgets::Helper
    end

  end
end