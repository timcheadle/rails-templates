module ApplicationHelper
  def is_active?(action)
    'active' if params[:controller] == 'welcome' && params[:action] == action
  end

  def markdown(&block)
    content = capture(&block)
    renderer = Redcarpet::Render::HTML
    Redcarpet::Markdown.new(renderer).render(content).html_safe
  end
end
