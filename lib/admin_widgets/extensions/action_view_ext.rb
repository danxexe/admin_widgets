module ActionView::Helpers::FormOptionsHelper
  def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
    options = collection.map do |element|
      option_html_attributes = (Array === element && element.size == 3 ? element.last : nil)
      [element.send(text_method), element.send(value_method), option_html_attributes].compact
    end
    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end
end