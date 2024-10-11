module MetadataPresenter
  class DropdownFieldset
    extend ActiveModel::Translation
    include ActiveModel::Validations
    include ActionView::Helpers

    attr_reader :selected_option

    # Constants for options could be defined here if they are static
    OPTIONS = %w[
      option1
      option2
      option3
      option4
    ].freeze

    def initialize(selected)
      @selected_option = sanitize_option(selected)
    end

    # A method to ensure the selected option is valid (exists in OPTIONS)
    def sanitize_option(selected)
      OPTIONS.include?(selected) ? selected : nil
    end

    # Method to return the selected option for the form
    def to_s
      selected_option
    end

    # Validation to ensure the selected option is included in OPTIONS
    validates :selected_option, inclusion: { in: OPTIONS, message: "%{value} is not a valid option" }
  end
end