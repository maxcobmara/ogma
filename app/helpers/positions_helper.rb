module PositionsHelper

  def nested_groups(positions)
     content_tag(:ul, :class => 'org') do
        positions.sort_by{|combo_code, v| v}.map do |position, sub_position|
           content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position)) + nested_groups(sub_position))
        end.join.html_safe
     end  
  end
  
  def position_details(position)
    "#{position.combo_code} <BR> #{(position.name).split('&').join('<BR>')}"
  end

end