module PositionsHelper

  def nested_groups(positions)
     content_tag(:ul) do
        positions.map do |position, sub_position|
           content_tag(:li, position.name.html_safe + (position.parent.html_safe rescue 0) + nested_groups(sub_position))
        end.join.html_safe
     end  
  end

end