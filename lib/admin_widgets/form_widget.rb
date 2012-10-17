module AdminWidgets
  class FormWidget < BaseFormWidget

    memoize :url, proc { helper.respond_to?(:resource_or_collection_path) ? helper.resource_or_collection_path : '' }
    memoize :save_button, true

    # DSL methods

    def fieldset(name, options = {}, &block)
      widget AdminWidgets::Form::FieldsetWidget.new(options.merge(:name => name, :parent => self, :block => block))
    end

    def buttons
      div :class => ['group', 'navform', 'wat-cf'] do
        rawtext helper.button_tag(:class => 'button') {
          helper.image_tag('icons/tick.png') +
          helper.t('resources.actions.save')
        } if save_button
        rawtext helper.link_to(helper.t('resources.actions.cancel'), cancel_url, :class => "text_button_padding link_button") if cancel_url
      end
    end
    
  end
end