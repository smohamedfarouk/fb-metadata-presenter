module MetadataPresenter
  class PagesController < EngineController
    def show
      @user_data = load_user_data # method signature
      @page ||= service.find_page_by_url(request.env['PATH_INFO'])

      if @page
        render template: @page.template
      else
        not_found
      end
    end
  end
end
