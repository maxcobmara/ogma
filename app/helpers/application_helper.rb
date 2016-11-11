module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ogma App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def active_page(active_page)
    @active == active_page ? "active" : ""
  end



  #nested_attribute_helper
  #def link_to_add_fields(name, f, association)
    #new_object = f.object.send(association).klass.new
    #id = new_object.object_id
    #fields = f.fields_for(association, new_object, child_index: id) do |builder|
      #render(association.to_s.singularize + "_fields", f: builder)
    #end
    #link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  #end
  #http://stackoverflow.com/questions/23777751/link-to-add-fields-unobtrusive-javascript-rails-4
  def link_to_add_fields(name, f, association, cssClass, title)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to name, "#", :onclick => h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => cssClass, :title => title
  end

  def link_to_remove_fields(name, f)
    #f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    #f.hidden_field(:_destroy)+( link_to name, "#",  :onclick=>h("remove_fields($(this),\"#{f.object_name}\")") )
    f.hidden_field(:_destroy)+( link_to name, "#",  :onclick=>h("remove_fields($(this),\"#{f}\")") )
    #link_to name, "#",  :onclick=>h("remove_fields($(this),\"#{f.object_name}\")")
    #link_to name, "#",  :onclick=>h("remove_fields($(this),\"#{f.object_name}[_destroy]}\")")
  end

  def currency(value)
    number_to_currency(value, :unit => "RM ", :separator => ".", :delimiter => ",", :precision => 2)
  end

  def ringgols(money)
    number_to_currency(money, :unit => "RM ", :separator => ".", :delimiter => ",", :precision => 2)
  end

  def pukka(points)
    number_with_precision(points, precision: 1)
  end

  def formatted_mykad(icno)
    "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
  end


  #legacy
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

#  def select_tag_for_filter(model, nvpairs, params)
#    options = { :query => params[:query] }
#    _url = url_for(eval("#{model}_url(options)"))
#    _html = %{<label for="show">Show:</label>}.html_safe
#    _html << %{<select name="show" id="show" class="selectpicker"}.html_safe
#    _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}.html_safe
#    nvpairs.each do |pair|
#      _html << %{<option value="#{pair[:scope]}"}.html_safe
#      if params[:show] == pair[:scope] || ((params[:show].nil? || params[:show].empty?) && pair[:scope] == "all")
#        _html << %{ selected="selected"}.html_safe
#      end
#      _html << %{>#{pair[:label]}}.html_safe
#      _html << %{</option>}.html_safe
#    end
#    _html << %{</select>}.html_safe
#  end

  def check_kin
    begin
      return yield
    rescue
      return "Empty"
    end
  end

  def check_kin_blank
    begin
      return yield
    rescue
      return ""
    end
  end

    ###devise
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def is_staff?
   current_user.userable_type == 'Staff'
  end
  
  def is_developer?
    current_user.roles.pluck(:authname).include?('developer')==true
  end
  
  def is_student?
    current_user.userable_type == 'Student'
  end
  
  def list_comma(arr)
    a=""
    arr.each{|x|a+=x+", "}
    a[0, a.size-2] if a.size > 0
  end
  
  def translated_list_comma(arr)
    a=""
    arr.each{|x|a+=I18n.t('user.'+x)+", "}
    a[0, a.size-2] if a.size > 0
  end
  
  def texteditor_content(string)
    #http://stackoverflow.com/questions/7414267/strip-html-from-string-ruby-on-rails
    ActionView::Base.full_sanitizer.sanitize(string, :tags => %w(img br p span), :attributes => %w(src style)).gsub!("&nbsp;", " ")
  end
  
end
