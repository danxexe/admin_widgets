module AdminWidgets
  class FiltersWidget < BaseFormWidget

    memoize :resource, nil
    memoize :as, 'search'
    memoize :resource, 'search'
    memoize :url, proc { helper.search_resources_path }
    memoize :method, 'post'

    def form_content
      hidden_fields
      content_block
      buttons
    end

    # DSL methods

    def field(name, operator, options = {})
      field_name = "#{name}_#{operator}"
      field_label = resource_class.human_attribute_name(name)
      field_value = params[as][field_name] rescue ''

      multiple = [:in, :all].include?(operator.to_sym)
      field_value = field_value.to_s.split(',') if multiple && field_value && !field_value.is_a?(Array)

      if options[:collection].present?
        value = nil
        selected = field_value
        include_blank = true
      else
        value = field_value
        selected = nil
        include_blank = nil
      end

      default_options = { :required => false, :label => field_label, :input_html => { :value => value, :multiple => multiple }, :selected => selected, :include_blank => include_blank, :hidden_field => false }
      rawtext form.input(field_name, default_options.merge(options))
    end

    def hidden_fields
      div :class => ['hidden-fields'] do
        %w[scope sort_field sort_direction].each do |hidden_field|
          rawtext form.input(hidden_field, :input_html => { :name => hidden_field, :value => params[hidden_field] }, :as => :hidden)
        end
      end
    end

    def buttons
      div :class => ['group', 'navform', 'wat-cf'] do
        rawtext helper.button_tag(:class => 'button', :name => 'filter', :value => as) {
          helper.image_tag('search-button.png') +
          helper.t('resources.actions.filter')
        }
        rawtext helper.link_to(helper.t('resources.actions.reset_filter'), cancel_url, :class => "text_button_padding link_button") if cancel_url
      end
    end

  end
end