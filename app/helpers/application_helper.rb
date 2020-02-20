module ApplicationHelper
  include Pagy::Frontend

  def title_helper(page_title = "")
    base_title = "DexFinder"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
