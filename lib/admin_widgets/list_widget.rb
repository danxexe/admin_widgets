module AdminWidgets
  class ListWidget < BaseWidget

    attr_accessor :table_class
    attr_reader :fields

    # Options

    memoize :table_id, proc { "#{resource_name}-table" }
    memoize :table_class, 'table'
    memoize :th_class, 'table-column'
    memoize :pagination_class, ['actions-bar', 'wat-cf']
    memoize :row_class, ActionView::Helpers::TextHelper::Cycle.new(:odd, :even)
    memoize :resource_class, proc { helper.resource_class }
    memoize :resource_name, proc { resource_class.name.underscore.pluralize }
    memoize :params, proc { helper.params }

    memoize :row_actions, true

    memoize :page_param, :page
    memoize :per_page_param, :per_page
    memoize :page, proc { params[page_param].presence || 1 }
    memoize :per_page, proc { params[per_page_param].presence || 25 }

    memoize :column_sorting, true
    memoize :sort_field_param, :sort_field
    memoize :sort_direction_param, :sort_direction
    memoize :sort_field, proc { params[sort_field_param].presence || :created_at }
    memoize :sort_direction, proc { params[sort_direction_param].presence || :desc }

    memoize :search_param, :search
    memoize :search, proc { params[search_param] }

    memoize :collection, proc { helper.collection }
    memoize :scoped_collection, proc { collection.send(sort_direction, sort_field).page(page).per(per_page) }


    delegate :edit_resource_path, :to => :helper
    delegate :resource_path, :to => :helper

    def initialize(*attrs)
      super(*attrs)

      @fields = []
    end

    def content
      content_block
      div :class => 'table-wrapper' do
        div :class => 'table-controls'
        div :class => 'table-content' do
          table :class => table_class, :id => table_id, :'data-highlight-id' => helper.flash[:highlight_id] do
            header
            body
          end
        end
      end
      pagination
    end


    # Content methods

    def header
      thead do
        tr do
          th :class => 'first'
          fields.each do |field|
            th :class => th_class, :'data-field-name' => field.name do
              header = Header.new(self, field)
              rawtext(column_sorting ? helper.link_to(header.label, header.url, :class => ['sortable', header.css_class]) : header.label)
            end
          end
          th :class => 'last'
        end
      end
    end

    def body
      tbody do
        scoped_collection.each do |object|
          tr :class => row_class, :'data-id' => object.id do
            td :class => 'first'
            fields.each do |field|
              td field.value_for(object)
            end
            td :class => 'last' do
              row_actions_for(object) if row_actions
            end
          end
        end
      end
    end

    def pagination
      div :class => pagination_class do
        div :class => 'results' do
          count = [scoped_collection.count(true), scoped_collection.total_count].join(I18n.t('of', :scope => 'views.pagination'))
          label = helper.t('views.pagination.results')
          rawtext "#{label} #{count}"
        end
        rawtext helper.paginate scoped_collection, :outer_window => 1, :inner_window => 5, :params => { :search => nil }, :param_name => page_param
      end
    end

    def row_actions_for(object)
      rawtext helper.link_to(label = helper.t('resources.actions.edit'), edit_resource_path(object), :class => 'edit', :alt => label)
      rawtext helper.link_to(label = helper.t('resources.actions.destroy'), resource_path(object), :method => :delete, :confirm => helper.t('resources.destroy.confirm'), :class => 'destroy', :alt => label)
    end


    # DSL methods

    def field(name, options = {}, &block)

      value_callback = lambda do |name, options|
        attribute_path = name.to_s.split('.')
        value = attribute_path.inject(self) {|r, v| r.try(v) rescue '' }

        # FIXME: This is bad code and I should feel bad. Extract it to a presenter maybe?
        if value.is_a? Time
          I18n.l(value, :format => :short)
        elsif value.is_a? Date
          I18n.l(value, :format => :default)
        elsif value.is_a? Array
          value.join(', ')
        elsif options[:i18n]
          I18n.t(value, :scope => options[:i18n])
        else
          value
        end
      end

      @fields << Field.new(self, name, options, value_callback)

      # Haml support hack
      ''
    end


    # Helper classes

    class Field
      attr_accessor :parent, :name, :options, :value_callback

      def initialize(parent, name, options, value_callback)
        @parent, @name, @options, @value_callback = parent, name, options, value_callback
      end

      def value_for(object)
        object.instance_exec(name, options, &value_callback)
      end
    end
    
    class Header
      extend AdminWidgets::Delegation

      attr_accessor :parent, :field

      def initialize(parent, field)
        @parent, @field = parent, field
      end

      delegate :helper, :params, :resource_class, :to => :parent
      with_options :to => :params, :hash => true do |c|
        c.delegate :sort_direction
        c.delegate :per_page
        c.delegate :page
        c.delegate :where
        c.delegate :scope
      end

      def sort_field
        field.name
      end

      def current_sort_field?
        helper.params[:sort_field] == sort_field.to_s
      end

      def next_sort_direction
        (current_sort_field? && sort_direction == 'asc') ? 'desc' : 'asc'
      end

      def sort_params
        {
          :sort_field => sort_field,
          :sort_direction => next_sort_direction,
          :per_page => per_page,
          :page => page,
          :where => where,
          :scope => scope
        }
      end

      def label
        resource_class.human_attribute_name(field.name)
      end

      def url
        helper.collection_path(sort_params)
      end

      def css_class
        sort_direction if current_sort_field?
      end
    end

  end
end