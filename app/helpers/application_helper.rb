module ApplicationHelper
  # Renders the flash[:notice], flash[:error], and flash[:warning] messages
  def render_flash
    str = ''
    if flash[:error]
      str = "<div id=\"flash\" class=\"error\">#{flash[:error]}</div>"
    elsif flash[:alert]
      str = "<div id=\"flash\" class=\"warning\">#{flash[:alert]}</div>"
    elsif flash[:notice]
      str = "<div id=\"flash\" class=\"notice\">#{flash[:notice]}</div>"
    else
      str = "<div id=\"flash\" class='flash-hidden' style=\"display:none;\"></div>"
    end
    str.html_safe
  end

  # Used in the main menu.
  # @return [Hash[String, Hash]]
  def generate_menu_definition
    menu_definition = {
        'Home' => {
          icon: 'menu-pipeline.png',
          link: '/'
        },
        'Jobs' => {
          icon: 'menu-pipeline.png',
          link: stored_jobs_path
        },
    }

    menu_definition
  end
end
