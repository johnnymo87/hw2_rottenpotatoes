module ApplicationHelper
  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? 'hilite' : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, movies_path(:sort => column, :direction => direction), {:class => css_class, :id => "#{column}_header"}
  end
end
