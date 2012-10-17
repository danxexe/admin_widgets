module AdminWidgets
  class ScopesWidget < BaseWidget

    def content
      div :class => 'scopes' do
        content_block
      end
    end


    # DSL methods

    def scope(name, options = {})
      rawtext Scope.new(self, name, options).to_html

      # Haml support hack
      ''
    end


    # Options

    memoize :collection, proc { helper.collection }
    memoize :resource_class, proc { helper.resource_class }
    memoize :current_scope, proc { helper.current_scope }
    memoize :params, proc { helper.params.reject{ |k,v| k == 'search' } }
    memoize :i18n_scope, proc { "mongoid.scopes.#{resource_class.to_s.underscore}" }


    # Helper classes

    class Scope < BaseWidget
      attr_accessor :parent, :name, :options

      def initialize(parent, name, options = {})
        super options.merge(:parent => parent, :name => name)
      end

      delegate :helper, :collection, :current_scope, :i18n_scope, :to => :parent

      memoize :label, proc { I18n.t(name, :scope => i18n_scope) }
      memoize :full_label, proc { label }
      memoize :default, false
      memoize :scope, proc { default ? nil : name }
      memoize :current_css_class, proc { 'current' if current? }
      memoize :css_class, proc { ['scope', current_css_class] }

      def current?
        (current_scope.nil? && default) || (current_scope.to_s == name.to_s)
      end

      def params
        parent.params.merge(:scope => scope)
      end

      def content
        rawtext helper.link_to(full_label, params, :class => css_class)
      end
    end

  end
end