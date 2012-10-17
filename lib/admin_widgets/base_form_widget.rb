module AdminWidgets
  class BaseFormWidget < BaseWidget

    attr_reader :form

    # TODO: WTF? Who the hell is overriding the 'form' method?
    def builder
      form
    end

    memoize :resource_class, proc { helper.resource_class }
    memoize :resource, proc { helper.resource }
    memoize :params, proc { helper.params }
    memoize :as, nil
    memoize :url, proc { '' }
    memoize :cancel_url, proc { helper.respond_to?(:collection_path) ? helper.collection_path : false }
    memoize :css_class, 'form'

    delegate :object, :to => :form

    def content
      rawtext around_form
    end

    def around_form
      form_method = @form ? :simple_fields_for : :simple_form_for

      helper.send(form_method, resource, :url => url, :as => as, :class => css_class, :html => @html) do |f|
        @form = f # IMPORTANT!

        capture do
          form_content
        end
      end
    end

    def form_content
      content_block
      buttons
    end

    # FIXME: Beware, arcane magic below. We are polluting the root widget with a instance variable, is there a better way to do this?
    def autofocus_done?
      root.instance_variable_get(:@autofocus_done)
    end
    def autofocus!(options = {})
      root.instance_variable_set(:@autofocus_done, true)
      { autofocus: true }.merge(options)
    end

    # DSL methods

    def field(name, options = {})
      options = autofocus!(options) unless autofocus_done?

      condition = options[:if]
      return if (condition.present? && !resource.instance_eval(&condition))

      form = (options[:nested] === false && self.respond_to?(:parent)) ? parent.form : self.form

      rawtext form.input(name, options)
    end
    
  end
end