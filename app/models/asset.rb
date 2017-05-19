class Asset < ActiveRecord::Base
  
  before_save :save_my_vars
  
  validates_presence_of :assignedto_id, :if => :bookable?
  validates_presence_of     :assettype
  
  has_many :asset_placements, :dependent => :destroy
  accepts_nested_attributes_for :asset_placements, :allow_destroy => true , :reject_if => lambda { |a| a[:location_id].blank? }
  has_many  :locations, :through => :asset_placements #Inventory
  belongs_to :hmlocation, :class_name => 'Location', :foreign_key => 'location_id' #Harta Modal
  
  belongs_to :suppliedby,  :class_name => 'AddressBook', :foreign_key => 'supplier_id'
  
  #belongs_to :location, :foreign_key => "location_id" --> not required - refer line 5
  #belongs_to :staff,    :class_name => 'Staff', :foreign_key => "assignedto_id"
  belongs_to :receiver, :class_name => 'Staff', :foreign_key => 'receiver_id'
  belongs_to :assignedto,   :class_name => 'Staff', :foreign_key => 'assignedto_id'
  
  belongs_to :category,     :class_name => 'Assetcategory', :foreign_key => 'category_id'
  has_many :asset_defects
  has_many :maints
  has_many :asset_loans
  has_many :asset_disposal
  has_many :asset_loss
  has_many :location_damages
  
  attr_accessor :cardno2
  
  scope :hm, -> { where(assettype: 1)}
  scope :inv, -> {where(assettype: 2)}
  scope :vehicle, -> {where(category_id: Asset.category_id_of_vehicle)}
  scope :otherasset, -> {where.not(category_id: 3)}
  scope :wlocation, -> { where.not(location_id: nil) }                                                              #usage - equery: kewpa7
  scope :wplacement, -> { where(id: AssetPlacement.joins(:asset).pluck(:asset_id).uniq) }  #usage - equery: kewpa7
  
  #usage - equery: kewpa7
  def self.assigned_locations
    location_ids=Asset.wlocation.pluck(:location_id)+AssetPlacement.joins(:asset).pluck(:location_id) # NOTE - same field name in use, AssetPlacement should comes 1st
  end

  #usage - equery: kewpa7
  def self.assigned_administrators
    admin_ids=Asset.wlocation.pluck(:assignedto_id)+AssetPlacement.joins(:asset).pluck(:staff_id)
  end
  
  def self.category_id_of_vehicle; Assetcategory.where('description ilike(?) or description ilike(?) or description ilike(?) or description ilike(?)', '%kenderaan%', '%Kenderaan%', '%vehicle%', '%Vehicle%').first.id; end
    
  def code_asset
    "#{assetcode} - #{name}"
  end
  
  def code_typename_name_modelname_serialno
    "#{assetcode} - #{typename} - #{name} - #{modelname} - #{serialno} "
  end
  
  def code_typename_serial_no
    "#{assetcode} - #{typename} - #{serialno} "
  end
  
  def name_modelname
    "#{name} - #{modelname} "
  end
  
  #usage - equery - kewpa13&14
  def name_type_model
    "#{name} | #{typename} | #{modelname}"
  end
  
  def save_my_vars
    if assetcode == nil
      self.assetcode = (suggested_serial_no).to_s
      if assettype == 2
          self.cardno = cardno2 + '-'+ quantity.to_s              #added - 4 Oct 2013 - quantity(form value)
          self.quantity = quantity.to_i - cardno2.to_i + 1        #added - 4 Oct 2013
      end
    end
  end

  def suggested_serial_no
      st = "KKM/BPL/010619/" if college_id==1 #kskbjb
      st = "JPM/APMM/PL/" if college_id==2 #amsas
      if assettype == 1
       md = "H/"
       st + md + syear + '/' + cardno                           #added - 4 Oct 2013
      else
       md = "I/"
       st + md + syear + '/' + cardno2 + '-' + quantity.to_s    #added - 4 Oct 2013
      end
      #st + md + syear + '/' + cardno
    end
    
    def syear
      receiveddate.year.to_s.last(2)
    end
    
  def render_origin
    (DropDown::COUNTRYLIST.find_all{|disp, value| value == country_id}).map {|disp, value| disp} [0]
  end
  
# TODO 
#     def extralist
# 
#     "
#     AS|American Samoa, 1684
#     AD|Andorra, 376
#     AO|Angola, 244
#     AI|Anguilla, 1264
#     AQ|Antarctica, 672
#     AG|Antigua And Barbuda, 1268
#     AM|Armenia, 374
#     AW|Aruba, 297
# 
#     AT|Austria,43
#     AZ|Azerbaijan,994
#     BS|Bahamas,1242
#     BH|Bahrain,973
#     BD|Bangladesh, 880
#     BB|Barbados, 1246
#     BY|Belarus, 375
#     BE|Belgium, 32
#     BZ|Belize, 501
#     BJ|Benin, 229
#     BM|Bermuda, 1441
#     BT|Bhutan, 975
#     BO|Bolivia, 591
#     BA|Bosnia And Herzegovina, 387
#     BW|Botswana, 267
#     BV|Bouvet Island,
#     IO|British Indian Ocean Territory,
#     BN|Brunei Darussalam, 673
#     BG|Bulgaria, 359
#     BF|Burkina Faso, 226
#     BI|Burundi, 257
#     KH|Cambodia, 855
#     CM|Cameroon, 237
#     CV|Cape Verde, 238
#     KY|Cayman Islands, 1345
#     CF|Central African Republic, 236
#     TD|Chad, 235
#     CL|Chile, 56
#     CX|Christmas Island, 61
#     CC|Cocos (keeling) Islands, 61
#     CO|Colombia, 57
#     KM|Comoros, 269
#     CG|Congo, 242
#     CD|Congo, The Democratic Republic Of The, 243
#     CK|Cook Islands, 682
#     CR|Costa Rica, 506
#     CI|Cote D'ivoire,
#     HR|Croatia, 385
#     CU|Cuba, 53
#     CY|Cyprus, 357
#     CZ|Czech Republic, 420
#     DK|Denmark, 45
#     DJ|Djibouti, 253
#     DM|Dominica, 1767
#     DO|Dominican Republic, 1809
#     TP|East Timor
#     EC|Ecuador, 593
#     EG|Egypt, 20
#     SV|El Salvador, 503
#     GQ|Equatorial Guinea, 240
#     ER|Eritrea, 291
#     EE|Estonia, 372
#     ET|Ethiopia, 251
#     FK|Falkland Islands (malvinas), 500
#     FO|Faroe Islands, 298
#     FJ|Fiji, 679
#     GF|French Guiana,
#     PF|French Polynesia, 689
#     TF|French Southern Territories
#     GA|Gabon, 241
#     GM|Gambia, 220
#     GE|Georgia, 995
#     GH|Ghana, 233
#     GI|Gibraltar, 350
#     GR|Greece, 30
#     GL|Greenland, 299
#     GD|Grenada, 1473
#     GP|Guadeloupe,
#     GU|Guam, 1671
#     GT|Guatemala, 502
#     GN|Guinea, 224
#     GW|Guinea-bissau, 245
#     GY|Guyana, 592
#     HT|Haiti, 509
#     HM|Heard Island And Mcdonald Islands
#     VA|Holy See (vatican City State), 39
#     HN|Honduras, 504
#     HU|Hungary, 36
#     IS|Iceland, 354
#     IR|Iran, Islamic Republic Of, 98
#     IQ|Iraq, 964
#     IL|Israel, 972
#     JM|Jamaica, 1876
#     JO|Jordan, 672
#     KZ|Kazakstan, 7
#     KE|Kenya, 254
#     KI|Kiribati, 686
#     KP|Korea, Democratic People's Republic Of
#     KR|Korea, Republic Of
#     KV|Kosovo, 381
#     KW|Kuwait, 965
#     KG|Kyrgyzstan, 996
#     LA|Lao People's Democratic Republic, 856
#     LV|Latvia, 371
#     LB|Lebanon, 961
#     LS|Lesotho, 266
#     LR|Liberia, 231
#     LY|Libyan Arab Jamahiriya, 218
#     LI|Liechtenstein, 423
#     LT|Lithuania, 370
#     LU|Luxembourg, 352
#     MO|Macau, 853
#     MK|Macedonia, The Former Yugoslav Republic Of, 389
#     MG|Madagascar, 261
#     MW|Malawi, 265
#     MV|Maldives, 960
#     ML|Mali, 223
#     MT|Malta, 354
#     MH|Marshall Islands, 692
#     MQ|Martinique,
#     MR|Mauritania, 222
#     MU|Mauritius, 231
#     YT|Mayotte, 262
#     FM|Micronesia, Federated States Of, 691
#     MD|Moldova, Republic Of, 373
#     MC|Monaco, 377
#     MN|Mongolia, 976
#     MS|Montserrat, 1664
#     ME|Montenegro, 382
#     MA|Morocco, 212
#     MZ|Mozambique, 258
#     MM|Myanmar, 95
#     NA|Namibia. 264
#     NR|Nauru, 674
#     NP|Nepal, 977
#     NL|Netherlands, 31
#     AN|Netherlands Antilles, 599
#     NC|New Caledonia, 687
#     NZ|New Zealand, 64
#     NI|Nicaragua, 505
#     NE|Niger, 227
#     NG|Nigeria, 234
#     NU|Niue, 683
#     NF|Norfolk Island, 672
#     MP|Northern Mariana Islands, 1670
#     NO|Norway, 47
#     OM|Oman, 968
#     PK|Pakistan, 92
#     PW|Palau, 680
#     PS|Palestinian Territory, Occupied,
#     PA|Panama, 507
#     PG|Papua New Guinea, 675
#     PY|Paraguay, 595
#     PE|Peru, 51
#     PH|Philippines, 63
#     PN|Pitcairn, 870
#     PL|Poland, 48
#     PT|Portugal, 351
#     PR|Puerto Rico, 1012
#     QA|Qatar, 974
#     RE|Reunion,
#     RO|Romania, 40
#     RU|Russian Federation, 7
#     RW|Rwanda, 250
#     SH|Saint Helena, 290
#     KN|Saint Kitts And Nevis, 1869
#     LC|Saint Lucia, 1758
#     PM|Saint Pierre And Miquelon, 508
#     VC|Saint Vincent And The Grenadines, 1784
#     WS|Samoa, 685
#     SM|San Marino, 378
#     ST|Sao Tome And Principe, 239
#     SA|Saudi Arabia, 966
#     SN|Senegal, 221
#     RS|Serbia, 381
#     SC|Seychelles, 248
#     SL|Sierra Leone, 232
#     SG|Singapore, 65
#     SK|Slovakia, 421
#     SI|Slovenia, 386
#     SB|Solomon Islands, 677
#     SO|Somalia, 252
#     ZA|South Africa, 27
#     SS|South Sudan,
#     GS|South Georgia And The South Sandwich Islands
#     ES|Spain, 34
#     LK|Sri Lanka, 94
#     SD|Sudan, 249
#     SR|Suriname, 597
#     SJ|Svalbard And Jan Mayen
#     SZ|Swaziland, 268
#     SE|Sweden, 46
#     CH|Switzerland, 41
#     SY|Syrian Arab Republic, 963
#     TW|Taiwan, Province Of China, 886
#     TJ|Tajikistan, 992
#     TZ|Tanzania, United Republic Of, 255
#     TH|Thailand, 66
#     TG|Togo, 228
#     TK|Tokelau, 690
#     TO|Tonga, 676
#     TT|Trinidad And Tobago, 1686
#     TN|Tunisia, 216
#     TR|Turkey, 90
#     TM|Turkmenistan, 993
#     TC|Turks And Caicos Islands, 1649
#     TV|Tuvalu, 688
#     UG|Uganda, 256
#     UA|Ukraine, 380
#     AE|United Arab Emirates, 971
#     GB|United Kingdom, 44
#     US|United States, 1
#     UM|United States Minor Outlying Islands
#     UY|Uruguay, 598
#     UZ|Uzbekistan, 998
#     VU|Vanuatu, 678
#     VE|Venezuela, 58
#     VN|Viet Nam, 84
#     VG|Virgin Islands, British
#     VI|Virgin Islands, U.s.
#     WF|Wallis And Futuna, 681
#     EH|Western Sahara
#     YE|Yemen, 967
#     ZM|Zambia, 260
#     ZW|Zimbabwe, 263"
#   end
end

# == Schema Information
#
# Table name: assets
#
#  assetcode            :string(255)
#  assettype            :integer
#  assignedto_id        :integer
#  bookable             :boolean
#  cardno               :string(255)
#  category_id          :integer
#  country_id           :integer
#  created_at           :datetime
#  engine_no            :string(255)
#  engine_type_id       :integer
#  id                   :integer          not null, primary key
#  is_disposed          :boolean
#  is_maintainable      :boolean
#  locassigned          :boolean
#  location_id          :integer
#  manufacturer_id      :integer
#  mark_as_lost         :boolean
#  mark_disposal        :boolean
#  modelname            :string(255)
#  name                 :string(255)
#  nationcode           :string(255)
#  orderno              :string(255)
#  otherinfo            :text
#  purchasedate         :date
#  purchaseprice        :decimal(, )
#  quantity             :integer
#  quantity_type        :string(255)
#  receiveddate         :date
#  receiver_id          :integer
#  registration         :string(255)
#  serialno             :string(255)
#  status               :integer
#  subcategory          :string(255)
#  supplier_id          :integer
#  typename             :string(255)
#  updated_at           :datetime
#  warranty_length      :integer
#  warranty_length_type :integer
#
