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
  
  def is_admin?
    current_user.roles.pluck(:authname).include?('administration')==true
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
  
  #8-10Feb2017 : NOTE - for use in exam_paper.pdf
  def texteditor_pdf(string)
    #allowed in prawn pdf - <b>, <i>, <u>, <strikethrough>, <sub>, <sup>, <font>, <color> and <link>
    str=""
    if string.include?("&nbsp;")
      str=string.gsub!("&nbsp;", " ")
    else
      str=string
    end
    if str.include?("&hellip;")
      str2=str.gsub!("&hellip;", "...")
    else
      str2=str
    end
    a=replace_span(str2)
    b=replace_para_newline(a)
    c=replace_strong(b)
  end
  
  def replace_para_newline(string)
    str=""
    if string.include?("<p>") && string.include?("</p>")
      w_para=string.split("<p>")
      for para in w_para
        if para.include?("</p>")
	  aaa=para.gsub!("</p>", "\n")
	  unless aaa.nil?
            str+=aaa
	  end
	else
	  str+=para
	end
      end
    else
      str=string
    end
    str
  end
  
  def replace_strong(string)
    str=""
    if string.include?("<strong>") && string.include?("</strong>")
      aaa=string.gsub!("<strong>", "<b>").gsub!("</strong>", "</b>")
      str+=aaa unless aaa.nil?
    else
      str=string
    end
    str
  end
  
  # NOTE: CKEditor - shall convert Word html data to simpler format 
  #for eg. "NI" - extracted from Ms Word doc: Letter Head TPSB.docx
  #NicEditor - saved data as : "</p><p lang="en-MY" align="left" style="line-height: 100%"><font face="Liberation Serif, serif"><font style="font-size: 12pt"><font color="#000080"><font face="Arial Black, serif"><font style="font-size: 18pt"><b>NI</b></font></font></font></font></font></p></div>"
  #CKEditor - saved data as : <span style="font-size:medium"><span style="color:#000080"><span style="font-size:x-large"><strong>NI</strong></span></span></span>
  def replace_span(string)
    span_arr=string.split("</span>")
    ####
    test_full=""
    for spn in span_arr
      if spn.include?("<span")
	####size#######
	extsizes=spn.scan('<span style="font-size:small">')
	extsizem=spn.scan('<span style="font-size:medium">')
	extsizel=spn.scan('<span style="font-size:large">')
	extsizexl=spn.scan('<span style="font-size:x-large">')
	extsizing=spn.scan('<span style="font-size:')
	extno=spn[/size:(.*?)"/,1]
	size_str=spn
	if extsizing !=[]
	  if extsizem !=[] 
            size_str=size_str.gsub!('<span style="font-size:medium">', '<font size="14">')+'</font>' 
	  end
	  if extsizexl !=[]
	    size_str=size_str.gsub!('<span style="font-size:x-large">', '<font size="18">')+'</font>'
	  end
	  if extsizes !=[]
	    size_str=size_str.gsub!('<span style="font-size:small">', '<font size="10">')+'</font>'
	  end
	  if extsizel !=[]
	    size_str=size_str.gsub!('<span style="font-size:large">', '<font size="16">')+'</font>' 
	  end
	  if extno.to_i!=0
	    size_str=size_str.gsub!(/<span style=\"font-size:#{extno}\">/, '<font size="'+extno+'">')+'</font>' 
	  end
	end
	####size#######
	#test_full+=size_str
	####color######
	extcolor=spn.scan('<span style="color:')
	color_str=size_str
	if extcolor !=[]
	  color_codes='#'+color_str[/#(.*?)"/,1]
	  if color_codes!=[]
            #text "kod warna je #{color_codes}"   -- fr pdf
	    color_str=color_str.gsub!(/<span style=\"color:#{color_codes}\">/, '<color rgb="'+color_codes+'">')+'</color>'
	  end
	end
	####color######
	test_full+=color_str
      else
        test_full+=spn
      end
    end 
    ####
    test_full
  end
  
  #calculate total height required for ea question in exam_paper.pdf
  def pdf_question_height(string)
    question_paras=texteditor_pdf(string).split("\n")
    question_height=10
    for question_para in question_paras
      question_height+=10 #basic per line
      if question_para.size > 1 #eliminate ENTER
	  para_length=strip_tags(question_para).size
	  para_lines=strip_tags(question_para).size/89
	  #-------------------------------------------------
	  #to collect all font sizes in ALL one liner para (max size in each para : in one line/para) 
	  #OR collect all font sizes in multiple liner para (max size in each para : in multiple line para)
	  oneline_fosz=[]
	  pars=question_para.split("<font si")      
	  for fontsize in pars                                 
	    ###
	    if fontsize.include?("ze")
	      sz=fontsize[/ze="(.*?)"/,1]
	      if sz=="small"
	        oneline_fosz << 10
	      elsif sz=="medium"
	        oneline_fosz << 14
	      elsif sz=="large"
	        oneline_fosz << 16
	      elsif sz=="x-large"
	        oneline_fosz << 18
	      else
	        oneline_fosz << sz.to_i
	      end
            end
	    ###
	  end
	  if oneline_fosz.count > 0
	    max_height=oneline_fosz.max
	    if para_lines == 0
	      question_height+=max_height                            #height applied for each one liner para
	    else
	      question_height+=max_height*para_lines          #height applied for all lines in each para
	    end
	  else
	    if para_lines == 0
	      question_height+=10
	    else
	      question_height+=10*para_lines
	    end
	  end
	  #------------------------------------------------
      end
    end
    question_height
  end
  
end
