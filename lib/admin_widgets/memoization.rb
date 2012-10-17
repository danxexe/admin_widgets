module AdminWidgets
	module Memoization
    def memoize(attribute, val_or_callback)
      ivar = "@#{attribute}"

      define_method attribute do
        if (current_val = instance_variable_get(ivar)).nil?
          value = val_or_callback.respond_to?(:call) ? instance_eval(&val_or_callback) : val_or_callback
          current_val = instance_variable_set(ivar, value)
        end
        current_val
      end
    end
  end
end