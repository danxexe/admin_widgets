module AdminWidgets
	module Delegation
    def delegate(*methods)
      options = methods.last
      keys = methods[0..-2]

      if options.is_a?(Hash) and options[:hash]
        keys.each do |key|
          define_method key do
            hash = self.send(options[:to])
            hash.send(:[], key)
          end
        end
      else
        super *methods
      end

    end
  end
end