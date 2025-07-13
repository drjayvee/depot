# frozen_string_literal: true

module VisitCount
  private

    def increment_visit_count
      session[:visit_count] ||= 0
      session[:visit_count] += 1

      @visit_count = session[:visit_count]
    end

    def reset_visit_count
      session[:visit_count] = 0
    end
end
