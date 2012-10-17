module AdminWidgets::Show
  class FieldsetWidget < AdminWidgets::ShowWidget

    attr_reader :parent
    attr_reader :name

    memoize :resource, proc { parent.resource.send(name) }
    memoize :legend, proc { parent.resource_class.human_attribute_name(name) }

    delegate :helper, :to => :parent

    def content
      rawtext(around_fieldset do
        super
      end)
    end

    def around_fieldset
      element('fieldset') do
        element('legend', legend)

        yield
      end
    end
    
  end
end