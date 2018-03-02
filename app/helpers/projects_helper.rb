module ProjectsHelper
  # def logo_of(company)
  #   if company.logo_file_exists?
  #     url = logo_url(company.logo)
  #     if company.url.present?
  #       link_to(image_tag(url), company.url)
  #     else
  #       image_tag(url)
  #     end
  #   end
  # end

  # def companies_check_box_tags(name, items)
  #   s = []
  #   items.each do |item|
  #     s << "<label>#{ check_box_tag name, item.id, false } #{h item.name}</label><br/>\n"
  #   end
  #   s.join.html_safe
  # end

  private

  def logo_url(logo)
    url_for( :only_path => false, :controller => 'attachments', :action => 'download', :id => logo, :filename => logo.filename )
  end
end
