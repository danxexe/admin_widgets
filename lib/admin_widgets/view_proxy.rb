module AdminWidgets
  class ViewProxy < ActiveSupport::BasicObject

    attr_accessor :widget

    def initialize(view, widget)
      @widget = widget
      @view = buffered_view(view)
    end

    def method_missing(method_name, *args, &block)
      target = case
        when widget.dsl_methods.include?(method_name.to_sym) then @widget
        else @view
      end

      target.send(method_name, *args, &block)
    end

    private

    # Manually initialize output buffers
    # This is needed for ActionView::Helpers::CaptureHelper
    def buffered_view(view)
      @view || begin
        init_output_buffer!(view)
        init_haml_buffer!(view)

        view
      end
    end

    def init_output_buffer!(view)
      view.output_buffer = ::ActionView::OutputBuffer.new
    end

    def init_haml_buffer!(view)
      return unless defined? ::Haml

      class << view
        include ::Haml::Helpers unless included_modules.to_a.include?(::Haml::Helpers)
      end

      view.init_haml_helpers
      view.instance_variable_set :@haml_buffer, ::Haml::Buffer.new(nil, :preserve => [], :encoding => 'UTF-8')
    end

  end
end