module AdminWidgets
  module Helper

    def admin_widget(name, options = {}, &block)
      widget_class = "::AdminWidgets::#{name.to_s.camelize}Widget".constantize
      options = options.merge(:controller => controller, :block => block)
      widget_class.new(options).to_html
    end

  end
end