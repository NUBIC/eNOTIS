module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login page/
      login_path

    when /the study page for id "([^\"]*)"/
      "/studies/#{$1}"

    when /the search page/
      search_path

    when /the hub page/
      hub_path

    when /the studies page/
      studies_path

    when /^the services page$/
      services_path
    when /^the services page for "([^\"]*)"$/
      edit_service_path($1)
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
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
