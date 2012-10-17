module AdminWidgets
  class BaseWidget < Erector::Widget
    extend AdminWidgets::Memoization
    extend AdminWidgets::Delegation

    # Outputs to a new buffer
    def capture(&block)
      original, @_output = output, Erector::Output.new
      instance_eval &block
      original.widgets.concat(output.widgets)
      output.to_s
    ensure
      @_output = original
    end

    def root
      parent and parent.root or self
    end

    def helper
      @controller.view_context
    end

    def method_missing(method_name, *args, &block)
      rawtext helper.send(method_name, *args, &block)
    end

    def content_block
      instance_eval &@block if @block
    end

  end
end