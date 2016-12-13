module Searchable
  extend ActiveSupport::Concern

  included do
    before_action :verify_search_param_presence, only: [:search]
  end

  def verify_search_param_presence
    return unless search_params[:term].blank?
    flash[:warning] = 'Please, input something in the search field!'
    redirect_to action: :index
  end

  def search_params
    params.require(:search).permit(:term)
  end
end
