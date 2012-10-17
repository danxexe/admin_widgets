module AdminWidgets::Form
  class FieldsetWidget < AdminWidgets::FormWidget

    attr_reader :parent
    attr_reader :name

    def resource
      form.object
    end

    delegate :helper, :to => :parent

    memoize :repeatable, false
    memoize :nested, true
    memoize :legend, proc { resource_class.human_attribute_name(name) }
    memoize :wrapper_html, {}

    def visible
      return @visible = true if @visible.nil?
      return @visible = @visible.call(resource) if @visible.respond_to? :call
      @visible
    end

    def content
      return simple_fieldset unless nested

      around_form do
        around_repeatable_collection do
          parent.form.simple_fields_for(name) do |form|
            @form = form # IMPORTANT!

            around_repeatable_group do
              content_block
            end
          end
        end
      end
    end

    def before
      @before = capture do
        div :class => 'before' do
          yield
        end
      end
      nil
    end

    def after
      @after = capture do
        div :class => 'after' do
          yield
        end
      end
      nil
    end

    def simple_fieldset
      @form = parent.form
      around_form do
        content_block
      end
    end

    def around_form
      wrapper_attrs = { :class => 'fieldset-wrapper' }
      wrapper_attrs.merge! :style => 'display: none' unless visible
      wrapper_attrs.merge! wrapper_html

      div wrapper_attrs  do
        if legend
          element('fieldset') do
            element('legend', legend)
            inside = capture { yield }
            rawtext @before
            rawtext inside
            rawtext @after
          end
        else
          yield
        end
      end
    end

    def around_repeatable_collection
      return yield unless repeatable

      div :class => 'repeatable-collection', :'data-repeatable' => repeatable do
        yield
      end
    end

    def around_repeatable_group
      return yield unless repeatable

      div :class => ['repeatable-group', form.object.class.name.underscore], :id => form.object._id do
        yield
      end
    end
    
  end
end