class SimpleForm::Inputs::CollectionInput
  def detect_common_display_methods
    collection_classes = detect_collection_classes

    if collection_classes.include?(Array)
      { :label => :first, :value => :second }
    elsif collection_includes_basic_objects?(collection_classes)
      { :label => :to_s, :value => :to_s }
    else
      sample = collection.first || collection.last

      { :label => SimpleForm.collection_label_methods.find { |m| sample.respond_to?(m) },
        :value => SimpleForm.collection_value_methods.find { |m| sample.respond_to?(m) } }
    end
  end
end