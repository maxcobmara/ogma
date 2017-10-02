module PositionsHelper

  def nested_groups(positions)
     content_tag(:ul) do
        # NOTE - http://stackoverflow.com/questions/16007384/arranging-ancestry-siblings-by-name-and-integer 
        #Category.siblings_of(params[:id]).order_by(name: :asc)
        pa=Position.where('name=? or tasks_main ILIKE(?) or tasks_other ILIKE(?)', 'Setiausaha Pejabat',  '%PA Pengarah%', '%PA Pengarah%').first
        positions.map do |position, sub_position|
          if (position.name.include?('Jangan Delete Dulu')==false) || is_developer?
             #####
             #sub_position.sort -> will just sort by ID
             subp=Position.children_of(position).order(combo_code: :asc)
             if position.is_root?
               #pa=Position.where('name=? or tasks_main ILIKE(?) or tasks_other ILIKE(?)', 'Setiausaha Pejabat',  '%PA Pengarah%', '%PA Pengarah%').first
               if pa 
                 #content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position))+content_tag(:adjunct, link_to(position_details2(pa).html_safe, staff_position_path(pa)))+ nested_groups(subp))
	         content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position))+content_tag(:adjunct, link_to(position_details2(pa).html_safe, staff_position_path(pa)))+ nested_groups(subp))
               else
                 content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position)) + nested_groups(subp))
               end
             else
	       if position!=pa
                 content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position)) + nested_groups(subp)) 
	       end
             end
             #####
          end
        end.join.html_safe
     end  
  end
  
  def unit_name(position)
    #if position.name=='Jurulatih'
    if !(position.is_root? || position.name=='Setiausaha Pejabat') && position.college.code=='amsas'
      a="<BR>(#{position.unit})"
    else
      a=""
    end
    a
  end
  
  def position_details(position)
    "#{position.combo_code}#{position.staff_id.nil? ? '' : ' *'} <BR> #{(position.name).split('&').join('<BR>') } #{unit_name(position)} <a href='/staff/positions/new?parent_id=#{position.id}'>(+)</a>"
  end
  
  def position_details2(position)
    "#{position.combo_code} <BR> #{(position.name).split('&').join('<BR>') } #{unit_name(position)}"
  end

end
# Keyser Söze <adjunct><i>Kobayashi</i></adjunct>   content_tag(:adjunct, position_details2(pa).html_safe) +