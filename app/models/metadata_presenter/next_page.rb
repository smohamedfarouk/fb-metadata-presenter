module MetadataPresenter
  class NextPage
    include ActiveModel::Model
    attr_accessor :service, :session, :user_data, :current_page_url

    def find
      return check_answers_page if return_to_check_your_answer?

      if conditionals?
        evaluate_conditionals
      elsif current_page_flow.present?
        service.find_page_by_uuid(current_page_flow.default_next)
      else
        service.next_page(from: current_page_url)
      end
    end

    private

    def check_answers_page
      session[:return_to_check_your_answer] = nil
      service.pages.find { |page| page.type == 'page.checkanswers' }
    end

    def return_to_check_your_answer?
      session[:return_to_check_your_answer].present?
    end

    def conditionals?
      current_page_flow.present? &&
        next_flow.present? &&
        next_flow_branch_object?
    end

    def evaluate_conditionals
      EvaluateConditionals.new(
        service: service,
        flow: next_flow,
        user_data: user_data
      ).page
    end

    def current_page
      service.find_page_by_url(current_page_url)
    end

    def current_page_uuid
      current_page.uuid
    end

    def current_page_flow
      service.flow_object(current_page_uuid)
    end

    def next_flow
      service.flow_object(current_page_flow.default_next)
    end

    def next_flow_branch_object?
      next_flow.branch?
    end
  end
end
