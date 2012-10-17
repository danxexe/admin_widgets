module AdminWidgets
  class WizardWidget < BaseFormWidget

    memoize :url, proc { helper.resource_or_collection_path }
    memoize :resource, proc { helper.resource }
    memoize :resource_plural_name, proc { resource.class.name.underscore.pluralize }
    memoize :display_finish_button, proc { true }

    attr_reader :current_step

    # DSL methods

    def fieldset(name, options = {}, &block)
      widget AdminWidgets::Form::FieldsetWidget.new(options.merge(:name => name, :parent => self, :block => block))
    end

    def steps_header

      # Default button
      rawtext helper.button_tag(:class => "default-step-button", :style => 'border:0;display:block;height:0;overflow:hidden;padding:0;', :name => 'change_step', :value => (@current_step.to_i + 1)) { 'Next' }

      ul :class => 'steps' do
        @steps.each_with_index do |step, index|
          li do
            active = @current_step == index + 1 ? ' active' : ''
            rawtext helper.button_tag(:class => "step#{active}", :name => 'change_step', :value => index + 1) {
              helper.t(step, :scope => "wizards.#{resource_plural_name}.steps", :index => index + 1)
            }
          end
        end
      end
    end

    def form_content
      content_block
      steps_header
      rawtext @content_buffer
      buttons
    end

    def buttons
      div :class => ['group', 'navform', 'wat-cf'] do
        rawtext helper.button_tag(:class => 'big button finish', :name => 'change_step', :value => @steps.size + 1) {
          helper.image_tag('icons/tick.png') +
          helper.t('resources.actions.finish')
        } if display_finish_button && @current_step == @steps.count
        rawtext helper.button_tag(:class => 'big button next', :name => 'change_step', :value => @current_step + 1) {
          helper.image_tag('icons/next.png') +
          helper.t('resources.actions.next')
        } if @current_step < @steps.count
        rawtext helper.button_tag(:class => 'big button previous', :name => 'change_step', :value => @current_step - 1) {
          helper.image_tag('icons/previous.png') +
          helper.t('resources.actions.previous')
        } if @current_step > 1
      end
    end

    def step(name, &block)
      @current_step ||= 1
      @content_buffer ||= ''
      @steps = [] if !@steps
      @steps << name
      @content_buffer += capture do
        div :class => 'step' do
          instance_eval &block if block
        end if @current_step == @steps.count
      end
    end

    def view(&block)
      @content_buffer ||= ''

      @content_buffer += capture do
        instance_eval &block if block
      end
    end

  end
end