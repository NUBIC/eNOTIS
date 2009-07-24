module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      default_path

    when /the login page/
      authentication_index_path

    when /the dashboard/
      dashboard_path
    
    when /the all studies page/
      studies_path
      
    when /my subjects/
      subjects_path
      
    when /the study page for id "([^\"]*)"/
      "/studies/#{$1}"
    
    when /the search page/
      search_path
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)