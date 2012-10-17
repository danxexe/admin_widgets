module AdminWidgets
  class ShowWidget < BaseWidget

    attr_reader :builder

    memoize :resource, proc { helper.resource }
    memoize :resource_class, proc { resource.class }

    def content
      rawtext show
    end

    def show
      helper.show_for(resource) do |builder|
        @builder = builder

        capture do
          content_block
        end
      end
    end

    def field(name, options = {})
      condition = options[:if]
      return if (condition.present? && !resource.instance_eval(&condition))

      rawtext resource.reflect_on_association(name) ? builder.association(name, options) : builder.attribute(name, options)
    end

    def fieldset(name, options = {}, &block)
      widget AdminWidgets::Show::FieldsetWidget.new(options.merge(:name => name, :parent => self, :block => block))
    end

  end
end