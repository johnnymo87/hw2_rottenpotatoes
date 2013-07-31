module ApplicationHelper
  def sortable(column, title=nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, movies_path(:sort => column, :direction => direction), :id => "#{column}_header"
  end
end
