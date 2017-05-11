class Repository < ActiveRecord::Base
  belongs_to :creator, class_name: 'Staff', foreign_key: 'staff_id'
  
  before_validation :set_upload_when_present
  after_save :remove_cache_upload
  
  serialize :data, Hash
  
  has_attached_file :uploaded,
                    :url => "/assets/uploads/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/uploads/:id/:style/:basename.:extension" #,
                  #  :styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :uploaded, :less_than => 50.megabytes
  validates_attachment_content_type :uploaded, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  
  validates :category, :title, :uploaded, :staff_id, presence: true, :if => :data_not_present?
  validates :document_type, :document_subtype, :title, :staff_id, :vessel_class, presence: true, :if => :data_is_present?  #:publish_date,  :uploaded,
  
  # NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start ####
  attr_accessor :uploadcache, :vessel_select, :ticker
  
  def set_upload_when_present
    unless uploadcache.blank?
      self.uploaded=AttachmentUploader.find(uploadcache.to_i).data if uploaded.blank?
    end
  end
  
  def remove_cache_upload
    unless uploadcache.blank?
      cached=AttachmentUploader.find(uploadcache.to_i)
      cached.destroy!
    end
  end
  ######## - workaround ends here - NOTE - to refer above (line 4 & 5), model/attachment_uploader.rb, controller & form.
  
  def render_category
    (Repository::CATEGORY.find_all{|disp, value| value == category }).map {|disp, value| disp}[0]
  end
  
  CATEGORY=[
                # Displayed               #Stored in db
            ['KKM', 1],
            ['KS', 2],
            ['WP', 3],
            ['TBL', 4],
            ['RAN', 5],
            ['Others', 6]
            ]
  
  def data_not_present?
    data.blank? == true
  end
  
  def data_is_present?
    data.blank? == false
  end
  
  #digital library parts

  scope :digital_library, -> { where.not(data: nil)}
  
  def vessel=(value)
    data[:vessel] = value
  end
  
  def vessel
    data[:vessel]
  end
  
  def document_type=(value)
    data[:document_type] = value
  end
  
  def document_type
    data[:document_type]
  end
  
  def document_subtype=(value)
    data[:document_subtype] = value
  end
  
  def document_subtype
    data[:document_subtype]
  end
  
  def refno=(value)
    data[:refno] = value
  end
  
  def refno
    data[:refno]
  end
  
  def publish_date=(value)
    data[:publish_date] = value
  end
  
  def publish_date
    data[:publish_date]
  end
  
  def total_pages=(value)
    data[:total_pages] = value
  end
  
  def total_pages
    data[:total_pages]
  end
  
  def copies=(value)
    data[:copies] = value
  end
  
  def copies
    data[:copies]
  end
  
  def location=(value)
    data[:location] = value
  end
  
  def location
    data[:location]
  end
  
  def remark=(value)
    data[:remark]=value
  end
  
  def remark
    data[:remark]
  end
  
  def classification=(value)
    data[:classification]=value
  end
  
  def classification
    data[:classification]
  end
  
  def code=(value)
    data[:code]=value
  end
  
  def code
    data[:code]
  end
  
  def vessel_class=(value)
    data[:vessel_class]=value
  end
  
  def vessel_class
    data[:vessel_class]
  end
  
  def equipment=(value)
    data[:equipment]=value
  end
  
  def equipment
    data[:equipment]
  end
  
  #Ransack - may also use 
  #define scope
  def self.vessel_search(query)
    ids=[]
    Repository.digital_library.each do |repo|
      unless repo.vessel.blank?
        ids << repo.id if repo.render_vessel.downcase.include?(query.downcase)
      else
        Repository.vessel_list2.each do |vesselclass, vessels| 
          if repo.render_vessel_class==vesselclass
            vessels.each{ |vessel| ids << repo.id if vessel.downcase.include?(query.downcase) }
          end
        end
      end
    end
    where(id: ids)
  end
  
  def self.refno_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.refno.downcase.include?(query.downcase)}
    where(id: ids)
  end
  
  def self.publish_date_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.publish_date==query}
    where(id: ids)
  end
  
  def self.location_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.location.downcase.include?(query.downcase)}
    where(id: ids)
  end
  
  def self.document_type_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.document_type==query}
    where(id: ids)
  end
  
  def self.document_subtype_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.document_subtype==query}
    where(id: ids)
  end
  
  def self.equipment_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.equipment==query}
    where(id: ids)
  end
  
  def self.classification_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.classification==query}
    where(id: ids)
  end
  
  def self.master_search(query)
    ids=[]
    Repository.digital_library.each do |repo|
      if query=="1"                 #master
        ids << repo.id if repo.vessel.blank?
      elsif query=="2"            #specific
        ids << repo.id unless repo.vessel.blank?
      end
    end
    where(id: ids)
  end

  def self.status_search(query)
    ids=[]
    loaned=Librarytransaction.marine_loaned_serial
    Repository.digital_library.each do |repo| 
      if query=="1"                                                               #available
        ids << repo.id  if loaned.include?(repo.code)==false
      elsif query=="2"                                                          #on loan
       ids << repo.id  if loaned.include?(repo.code)==true
      end
    end
    where(id: ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:vessel_search, :refno_search, :publish_date_search, :location_search, :document_type_search, :document_subtype_search, :classification_search, :status_search, :master_search, :equipment_search]
  end  
  
  def self.document
    [[I18n.t('repositories.book'), '1'],
     [I18n.t('repositories.drawing'), '2'],
     [I18n.t('repositories.test_trials'), '3']
     ]
  end
  
  def self.subdocument_old
    [[I18n.t('repositories.propulsion'), '1'],
     [I18n.t('repositories.auxiliaries'), '9'],
     [I18n.t('repositories.electrical'), '2'],
     [I18n.t('repositories.weapon'), '3'],
     [I18n.t('repositories.navigation'), '4'],
     [I18n.t('repositories.communication'), '5'],
     [I18n.t('repositories.hull_fitting'), '6'],
     [I18n.t('repositories.life_equipment'), '7'],
     [I18n.t('repositories.damage_safety'), '8']
     ]
  end
  
  def self.subdocument
    [[I18n.t('repositories.main_propulsion'), '1'],
    [I18n.t('repositories.electrical_power'), '2'],
    [I18n.t('repositories.steering_arrangement'), '3'],
    [I18n.t('repositories.sea_water_service'), '4'],
    [I18n.t('repositories.fresh_water_service'), '5'],
    [I18n.t('repositories.fuel_and_lubricant'), '6'],
    [I18n.t('repositories.compressed_air'), '7'],
    [I18n.t('repositories.refrigerator'), '8'],
    [I18n.t('repositories.life_saving_equipment'), '9'],
    [I18n.t('repositories.fire_fighting'), '10'],
    [I18n.t('repositories.hull_and_outfit'), '11'],
    [I18n.t('repositories.deck_machinery'), '12'],
    [I18n.t('repositories.weapon_system'), '13'],
    [I18n.t('repositories.navigational_aid'), '14'],
    [I18n.t('repositories.communication'), '15'],
    [I18n.t('repositories.domestic_equipment'), '16'],
    [I18n.t('repositories.ship_monitoring'), '17'],
    [I18n.t('repositories.degaussing'), '18'],
    [I18n.t('repositories.workshop_machinery'), '19'],
    [I18n.t('repositories.stabilising_pump'), '20'],
    [I18n.t('repositories.diving_facility'), '21'],
    [I18n.t('repositories.sanitary_and_drainage'), '22'],
    [I18n.t('repositories.boats'), '23'],
    [I18n.t('repositories.special_tools_test'), '24'],
    [I18n.t('repositories.surveyhydrographic'), '25'],
    [I18n.t('repositories.cathodic_protection'), '26']]
  end
  
  def self.equipment_list
    [[I18n.t('repositories.main_propulsion'),
      [[I18n.t('select'),''], 
       [I18n.t('repositories.main_engine'), '1'], 
       [I18n.t('repositories.gearbox'), '2'],
       [I18n.t('repositories.cpp_system'), '3'],
       [I18n.t('repositories.controllable_pitch_propeller'), '4'],
       [I18n.t('repositories.shaft'), '5'],
       [I18n.t('repositories.sternseal'), '6'],
       [I18n.t('repositories.shaft_brake'), '7'],
       [I18n.t('repositories.heat_exchanger'), '8'],
       [I18n.t('repositories.main_engine_lub_oil_filling_pump'), '9'],
       [I18n.t('repositories.me_lub_oil_filling_pump_motor'), '10'],
       [I18n.t('repositories.main_engine_lub_oil_pump'), '11'],
       [I18n.t('repositories.me_lub_oil_pump_motor'), '12'],
       [I18n.t('repositories.main_engine_fresh_water_cooling_pump'), '13'],
       [I18n.t('repositories.me_fresh_cooling_water_pump_control'), '14'],
       [I18n.t('repositories.main_engine_fuel_oil_feeder_pump'), '15'],
       [I18n.t('repositories.me_fuel_oil_feeder_pump_motor'), '16'],
       [I18n.t('repositories.main_engine_sea_water_cooling_pump'), '17'],
       [I18n.t('repositories.me_sea_cooling_water_pump_motor'), '18'],
       [I18n.t('repositories.sea_water_cooling_pump'), '19'],
       [I18n.t('repositories.sea_cooling_water_pump_motor'), '20'],
       [I18n.t('repositories.gearbox_lub_oil_pump'), '21'],
       [I18n.t('repositories.gearbox_lub_oil_pump_motor'), '22'],
       [I18n.t('repositories.cpp_hydraulic_pump'), '23'],
       [I18n.t('repositories.cpp_hydraulic_pump_motor'), '24'],
       [I18n.t('repositories.flexible_coupling'), '25'],
       [I18n.t('repositories.shaft_torque_meter'), '26'],
       [I18n.t('repositories.pitch_control_unit'), '27']] ],   
    [I18n.t('repositories.electrical_power'), 
     [[I18n.t('select'),''], 
      [I18n.t('repositories.auxiliary_engine'), '28'],
      [I18n.t('repositories.emergency_diesel_engine'), '29'],
      [I18n.t('repositories.box_cooler'), '30'],
      [I18n.t('repositories.main_alternator'), '31'],
      [I18n.t('repositories.emergency_altenator'), '32'],
      [I18n.t('repositories.main_switchboard'), '33'],
      [I18n.t('repositories.emergency_switchboard'), '34'],
      [I18n.t('repositories.transformer'), '35'],
      [I18n.t('repositories.shore_supply_connection_box'), '36'],
      [I18n.t('repositories.battery_charger_rectifier_em_diesel'), '37'],
      [I18n.t('repositories.battery_charger_rectifier_automation'), '38'],
      [I18n.t('repositories.battery_charger_rectifier_navicom'), '39'],
      [I18n.t('repositories.battery_charger_rectif_port_batt'), '40'],
      [I18n.t('repositories.ups_static_converter'), '41'],
      [I18n.t('repositories.dbp_distribution_deck_aft'), '42'],
      [I18n.t('repositories.dbl_lighting_distribution'), '43'],
      [I18n.t('repositories.dbel_emergency_lighting_distribution'), '44'],
      [I18n.t('repositories.dbn_distribution_230v'), '45'],
      [I18n.t('repositories.dbs_distribution_socket'), '46'],
      [I18n.t('repositories.dbh_heating_distribution'), '47'],
      [I18n.t('repositories.ups_converter_40kva'), '48'],
      [I18n.t('repositories.shaft_earthing_device'), '49'],
      [I18n.t('repositories.mcc1_main_engine_room'), '50'],
      [I18n.t('repositories.mcc2_main_engine_room'), '51'],
      [I18n.t('repositories.mcc3_auxiliary_engine_room'), '52'],
      [I18n.t('repositories.mcc4_auxiliary_engine_room'), '53'],
      [I18n.t('repositories.emergency_motor_control_centre'), '54'],
      [I18n.t('repositories.static_converter_400hz'), '55'] ]],
    [I18n.t('repositories.steering_arrangement'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.steering_gear'), '56'],
      [I18n.t('repositories.steering_gear_pump_motor'), '57'],
      [I18n.t('repositories.steering_gear_pump_motor_starter'), '58'],
      [I18n.t('repositories.bow_thruster'), '59'],
      [I18n.t('repositories.bow_thruster_motor'), '60'],
      [I18n.t('repositories.bow_thruster_motor_speed_controller'), '61'],
      [I18n.t('repositories.rudder_position_indicator_equipment'), '62'] ]],
    [I18n.t('repositories.sea_water_service'), 
     [[I18n.t('select'),''], 
      [I18n.t('repositories.hull_and_fire_pump'), '63'],
      [I18n.t('repositories.hull_and_fire_pump_motor'), '64'],
      [I18n.t('repositories.hull_and_fire_pump_motor_starter'), '65'],
      [I18n.t('repositories.emergency_fire_pump'), '66'],
      [I18n.t('repositories.sea_water_pump_motor'), '67'],
      [I18n.t('repositories.water_ballast_tanks'), '68']]],
    [I18n.t('repositories.fresh_water_service'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.fresh_water_hydrophore_pump'), '69'],
      [I18n.t('repositories.fresh_water_hydrophore_pump_motor'), '70'],
      [I18n.t('repositories.fw_hydrophone_pump_motor_starter'), '71'],
      [I18n.t('repositories.hot_water_circulating_pump'), '72'],
      [I18n.t('repositories.hot_water_circulating_pump_motor'), '73'],
      [I18n.t('repositories.fresh_water_refilling_pump'), '74'],
      [I18n.t('repositories.fw_water_refilling_pump_motor'), '75'],
      [I18n.t('repositories.fresh_water_generator'), '76'],
      [I18n.t('repositories.fw_generator_filter_pump_motor'), '77'],
      [I18n.t('repositories.fw_water_generator_high_pressure_pump_motor'), '78'],
      [I18n.t('repositories.fw_generator_booster_pump_motor'), '79'],
      [I18n.t('repositories.fw_generator_motor_controller'), '80'],
      [I18n.t('repositories.fresh_water_transfer_pump'), '81'],
      [I18n.t('repositories.fresh_water_transfer_pump_motor'), '82'],
      [I18n.t('repositories.fresh_water_metering_pump'), '83'],
      [I18n.t('repositories.fresh_water_metering_pump_motor'), '84'],
      [I18n.t('repositories.fresh_water_tanks'), '85'],
      [I18n.t('repositories.cooling_water_tank'), '86'],
      [I18n.t('repositories.cooling_fw_exp_tank_main_engine'), '87'],
      [I18n.t('repositories.cooling_fw_xp_tank_aux_engine'), '88'],
      [I18n.t('repositories.fresh_water_hydrophore_tank'), '89']]],
      [I18n.t('repositories.fuel_and_lubricant'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.fuel_oil_transfer_pump'), '90'],
      [I18n.t('repositories.fuel_oil_transfer_pump_motor'), '91'],
      [I18n.t('repositories.lubricating_oil_separator'), '92'],
      [I18n.t('repositories.dirty_oil_discharge_pump'), '93'],
      [I18n.t('repositories.dirty_oil_discharge_pump_motor'), '94'],
      [I18n.t('repositories.fuel_oil_filter_water_separator'), '95'],
      [I18n.t('repositories.fo_filter_water_separator_pump_motor'), '96'],
      [I18n.t('repositories.fo_filter_water_separator_motor_starter'), '97'],
      [I18n.t('repositories.petrol_pump_unit'), '98'],
      [I18n.t('repositories.petrol_pump_motor'), '99'],
      [I18n.t('repositories.diesel_oil_pump_unit'), '100'],
      [I18n.t('repositories.diesel_oil_pump_motor'), '101'],
      [I18n.t('repositories.lub_oil_storage_tanks'), '102'],
      [I18n.t('repositories.fuel_oil_tanks'), '103'],
      [I18n.t('repositories.fuel_oil_settling_tanks'), '104'],
      [I18n.t('repositories.fuel_oil_day_tank_main_engine'), '105'],
      [I18n.t('repositories.fuel_oil_day_tank_auxiliary_engine'), '106'],
      [I18n.t('repositories.fuel_oil_day_tank_emergency_engine'), '107'],
      [I18n.t('repositories.fuel_oil_overflow_tank'), '108'],
      [I18n.t('repositories.fuel_oil_leak_off_tank'), '109'],
      [I18n.t('repositories.dirty_oil_tank'), '110'],
      [I18n.t('repositories.petrol_cans'), '111'],
      [I18n.t('repositories.petrol_tank'), '112'],
      [I18n.t('repositories.hydraulic_oil_storage_tank'), '113'],
      [I18n.t('repositories.bow_thruster_lub_oil_storage_tank'), '114'],
      [I18n.t('repositories.fuel_oil_intermediate_tank'), '115']]],
    [I18n.t('repositories.compressed_air'), 
     [[I18n.t('select'),''],
       [I18n.t('repositories.starting_air_compressor'), '116'],
       [I18n.t('repositories.starting_air_compressor_motor'), '117'],
       [I18n.t('repositories.diesel_driven_emergency_air_compressor'), '118'],
       [I18n.t('repositories.emergency_air_compressor_diesel_engine'), '119'] ]],
    [I18n.t('repositories.refrigerator'), 
     [[I18n.t('select'),''],
       [I18n.t('repositories.chilled_water_unit'), '120'],
       [I18n.t('repositories.chilled_water_unit_chilled_water_pump'), '121'],
       [I18n.t('repositories.chilled_water_unit_sea_water_pump'), '122'],
       [I18n.t('repositories.air_handling_unit'), '123'],
       [I18n.t('repositories.chilled_water_unit_compressor_motor'), '124'],
       [I18n.t('repositories.chilled_water_unit_cw_pump_motor'), '125'],
       [I18n.t('repositories.chilled_water_unit_sw_pump_motor'), '126'],
       [I18n.t('repositories.chilled_water_unit_switchboard'), '127'],
       [I18n.t('repositories.chilled_and_sw_pump_motor_switchboard'), '127'],
       [I18n.t('repositories.provision_cooling_unit'), '128'],
       [I18n.t('repositories.provision_cooling_unit_compressor_motor'), '129'],
       [I18n.t('repositories.provision_cooling_unit_sea_water_pump'), '130'],
       [I18n.t('repositories.provision_cooling_unit_sw_pump_motor'), '131'],
       [I18n.t('repositories.provision_cooling_unit_switchboard'), '132'],
       [I18n.t('repositories.rcu_sea_water_pump'), '133'],
       [I18n.t('repositories.rcu_sea_water_pump_motor'), '134'],
       [I18n.t('repositories.recirculating_cooling_unit'), '135'],
       [I18n.t('repositories.supply_fan'), '136'],
       [I18n.t('repositories.exhaust_fan'), '137'],
       [I18n.t('repositories.working_room_ventilation_switchboard'), '138'],
       [I18n.t('repositories.acu_fan'), '139'],
       [I18n.t('repositories.air_conditioning_switchboard'), '140'],
       [I18n.t('repositories.acu_heatinf_elements'), '141'],
       [I18n.t('repositories.engine_room_ventilation_switchbord'), '142'],
       [I18n.t('repositories.supply_exh_trunking_mc_space'), '143'],
       [I18n.t('repositories.supply_exh_trunking_compartments'), '144']]],
    [I18n.t('repositories.life_saving_equipment'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.life_buoy_light'), '145'],
      [I18n.t('repositories.life_buoys'), '146'],
      [I18n.t('repositories.life_jackets'), '147'],
      [I18n.t('repositories.life_rafts'), '148'],
      [I18n.t('repositories.safety_belts'), '149'],
      [I18n.t('repositories.survival_suits'), '150'],
      [I18n.t('repositories.stretcher'), '151'] ]],
    [I18n.t('repositories.fire_fighting'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.co2_system'), '152'],
      [I18n.t('repositories.co2_fire_extinguisher'), '153'],
      [I18n.t('repositories.gas_water_fire_extinguiser'), '154'],
      [I18n.t('repositories.dry_powder_extingusher'), '155'],
      [I18n.t('repositories.foam_fire_extinguisher'), '156'],
      [I18n.t('repositories.combine_spray_fire_extinguisher'), '157'],
      [I18n.t('repositories.pressure_holding_pump'), '158'],
      [I18n.t('repositories.pressure_holding_pump_motor'), '159'],
      [I18n.t('repositories.fire_alarm_system'), '160']]],
    [I18n.t('repositories.hull_and_outfit'),
     [[I18n.t('select'),''],
      [I18n.t('repositories.underwater_hull_and_boot_topping_area'), '161'],
      [I18n.t('repositories.propeller_shaft_bracket'), '162'],
      [I18n.t('repositories.rudder'), '163'],
      [I18n.t('repositories.sea_chest_gratings'), '164'],
      [I18n.t('repositories.bow_thruster_tunnel'), '165'],
      [I18n.t('repositories.replenishment_at_sea_arrangement'), '166'],
      [I18n.t('repositories.refueling_at_sea_arrangement'), '167'],
      [I18n.t('repositories.jack_and_ensign_staff_fittings'), '168'],
      [I18n.t('repositories.deck_scuppers_and_scupper_pipes'), '169'],
      [I18n.t('repositories.dressing_line_and_fittings'), '170'],
      [I18n.t('repositories.awning_and_fittings'), '171'],
      [I18n.t('repositories.towing_and_fittings'), '172'],
      [I18n.t('repositories.portable_f_fighting_extinguisher_bracket'), '173'],
      [I18n.t('repositories.petrol_stowage_rack'), '174'],
      [I18n.t('repositories.accommodation_ladder'), '175'],
      [I18n.t('repositories.brow_ladder'), '176'],
      [I18n.t('repositories.bollards'), '177'],
      [I18n.t('repositories.stanchions_quardrails_and_handrails'), '178'],
      [I18n.t('repositories.scrambling_net'), '179'],
      [I18n.t('repositories.brow_safety_net'), '180'],
      [I18n.t('repositories.lifting_net'), '181'],
      [I18n.t('repositories.anchors'), '182'],
      [I18n.t('repositories.anchors_cables_and_fittings'), '183'],
      [I18n.t('repositories.mast'), '184'],
      [I18n.t('repositories.bosuns_chair_plank_stages_fittings'), '185'],
      [I18n.t('repositories.eyeplates_and_eyebolts'), '186'],
      [I18n.t('repositories.roller_fairleads'), '187'],
      [I18n.t('repositories.hawser_reels'), '188'],
      [I18n.t('repositories.portable_chain_block'), '189'],
      [I18n.t('repositories.blobk_sheaves_and_associated_cordage'), '190'],
      [I18n.t('repositories.inside_staircase'), '191'],
      [I18n.t('repositories.outside_ladder'), '192'],
      [I18n.t('repositories.breather_pipe'), '193'],
      [I18n.t('repositories.tag_list_and_nbcd_markings'), '194'],
      [I18n.t('repositories.exhaust_trunking'), '195'],
      [I18n.t('repositories.sside_transform_struct_wline'), '196'],
      [I18n.t('repositories.superstructure_plating'), '197'],
      [I18n.t('repositories.machinery_bilges'), '198'],
      [I18n.t('repositories.watertight_doors'), '199'],
      [I18n.t('repositories.non_watertight_doors'), '200'],
      [I18n.t('repositories.watertight_hatches'), '201'],
      [I18n.t('repositories.scuttles'), '202'],
      [I18n.t('repositories.windows'), '203'],
      [I18n.t('repositories.windscreens'), '204'],
      [I18n.t('repositories.funnel'), '205'],
      [I18n.t('repositories.cargo_hatch'), '206'],
      [I18n.t('repositories.flush_deck_hatches'), '207'],
      [I18n.t('repositories.weather_decks'), '208'],
      [I18n.t('repositories.compartments'), '209'],
      [I18n.t('repositories.chain_locker'), '210'],
      [I18n.t('repositories.elect_compts_wshop_bridge_deck'), '211'],
      [I18n.t('repositories.elect_compts_wshop_main_deck'), '212'],
      [I18n.t('repositories.elect_compts_wshop_tween_deck'), '213'],
      [I18n.t('repositories.elect_compts_wshop_swage_deck'), '214'],
      [I18n.t('repositories.elect_compts_wshop_fcastle_deck'), '215'],
      [I18n.t('repositories.machinery_space'), '216'],
      [I18n.t('repositories.mechanical_workshop'), '217'],
      [I18n.t('repositories.pantries_dining_hall_galley'), '218'],
      [I18n.t('repositories.messes_cabons_off_space_bridge_deck'), '219'],
      [I18n.t('repositories.messes_cabons_off_space_boat_deck'), '220'],
      [I18n.t('repositories.messes_cabons_off_space_fcastle_dk'), '221'],
      [I18n.t('repositories.messes_cabons_off_space_main_deck'), '222'],
      [I18n.t('repositories.messes_cabons_off_space_tween_deck'), '223'],
      [I18n.t('repositories.messes_cabons_off_space_swage_deck'), '224'],
      [I18n.t('repositories.heads_showers_laundry_room_boat_deck'), '225'],
      [I18n.t('repositories.heads_showers_laundry_room_fcastle_deck'), '226'],
      [I18n.t('repositories.heads_showers_laundry_room_main_deck'), '227'],
      [I18n.t('repositories.heads_showers_laundry_room_tween_deck'), '228'],
      [I18n.t('repositories.heads_showers_laundry_room_swage_deck'), '229'],
      [I18n.t('repositories.cold_and_cool_rooms'), '230'],
      [I18n.t('repositories.ammunition_explosives_gunners_stores'), '231'],
      [I18n.t('repositories.store_rooms_forecastle_deck'), '232'],
      [I18n.t('repositories.store_rooms_main_deck'), '233'],
      [I18n.t('repositories.store_rooms_tween_deck'), '234'],
      [I18n.t('repositories.store_rooms_stowage_deck'), '235'],
      [I18n.t('repositories.cofferdam'), '236'],
      [I18n.t('repositories.air_conditioning_room'), '237'],
      [I18n.t('repositories.diving_room'), '238'],
      [I18n.t('repositories.steering_gear_room'), '239'],
      [I18n.t('repositories.bow_thruster_room'), '240'],
      [I18n.t('repositories.fresh_water_treatment_room'), '241'],
      [I18n.t('repositories.garbage_disposal_room'), '242'],
      [I18n.t('repositories.anterooms'), '243'],
      [I18n.t('repositories.co2_room'), '244'],
      [I18n.t('repositories.fuel_oil_refuelling_station'), '245'],
      [I18n.t('repositories.petrol_refuelling_station'), '246'],
      [I18n.t('repositories.escape_trunking'), '247']]],
    [I18n.t('repositories.deck_machinery'),
     [[I18n.t('select'),''],
      [I18n.t('repositories.stern_mooring_winch'), '248'],
      [I18n.t('repositories.stern_mooring_winch_motor'), '249'],
      [I18n.t('repositories.stern_anchor_mooring_winch'), '250'],
      [I18n.t('repositories.stern_anchor_mooring_winch_motor'), '251'],
      [I18n.t('repositories.stern_anchor_moor_winch_motor_controller'), '252'],
      [I18n.t('repositories.boat_davit'), '253'],
      [I18n.t('repositories.boat_davit_motor'), '254'],
      [I18n.t('repositories.boat_davit_motor_controller'), '255'],
      [I18n.t('repositories.boat_davit_hydraulic_motor'), '256'],
      [I18n.t('repositories.crane'), '257'],
      [I18n.t('repositories.crane_hydraulic_motor'), '258'],
      [I18n.t('repositories.crane_hydraulic_motor_starter'), '259'],
      [I18n.t('repositories.combined_rescuework_boat_davit'), '260'],
      [I18n.t('repositories.combined_rescuework_boat_davit_motor'), '261'],
      [I18n.t('repositories.combined_rescuework_boat_davit_starter'), '262'],
      [I18n.t('repositories.radial_boom_davit'), '263'],
      [I18n.t('repositories.ctd_bottomless_winch'), '264'],
      [I18n.t('repositories.ctd_bottomless_winch_motor'), '265'],
      [I18n.t('repositories.ctd_bottomless_winch_motor_controller'), '266'],
      [I18n.t('repositories.life_raft_davit'), '267'],
      [I18n.t('repositories.side_scan_sonar_winch'), '268'],
      [I18n.t('repositories.side_scan_sonar_winch_motor'), '269'],
      [I18n.t('repositories.side_scan_sonar_winch_motor_controller'), '270'],
      [I18n.t('repositories.bow_anchor_mooring_winch'), '271'],
      [I18n.t('repositories.bow_anchor_mooring_winch_motor'), '272'],
      [I18n.t('repositories.bow_anchor_mooring_winch_motor_controller'), '273'],
      [I18n.t('repositories.accommodation_ladder_winch_motor'), '274'],
      [I18n.t('repositories.accommodation_ladder_winch_motor_starter'), '275']]],
    [I18n.t('repositories.weapon_system'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.weapon_and_weapon_system'), '276']]],
    [I18n.t('repositories.navigational_aid'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.navigation_light'), '277'],
      [I18n.t('repositories.window_wiper'), '278'],
      [I18n.t('repositories.windscreen_wiper_motor_control'), '279'],
      [I18n.t('repositories.radarpilot_xband'), '280'],
      [I18n.t('repositories.multipilot_sband'), '281'],
      [I18n.t('repositories.electromagnetic_log'), '282'],
      [I18n.t('repositories.atlas_echograph_481'), '283'],
      [I18n.t('repositories.chartpilot'), '284'],
      [I18n.t('repositories.gyro_compass_equipment'), '285'],
      [I18n.t('repositories.steering_repeater_compass'), '286'],
      [I18n.t('repositories.bearing_repeater_compass'), '287'],
      [I18n.t('repositories.digital_repeater_compass'), '288'],
      [I18n.t('repositories.combined_wind_sensor'), '289'],
      [I18n.t('repositories.differential_global_positioning_system'), '290']]],
    [I18n.t('repositories.communication'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.operator_console'), '291'],
      [I18n.t('repositories.vhf_duplex_radio_telephone_debeg_6347'), '292'],
      [I18n.t('repositories.handset'), '293'],
      [I18n.t('repositories.gmdss_console'), '294'],
      [I18n.t('repositories.mfhf_controllerreceiver_dsc_9000'), '295'],
      [I18n.t('repositories.vhf_transceiver_telecar_10'), '296'],
      [I18n.t('repositories.inmarset_c_trx_debeg_322b'), '297'],
      [I18n.t('repositories.satellite_telephone_trx_sp_1600m'), '298'],
      [I18n.t('repositories.hf_ssb_radio_system_trp_7000'), '299'],
      [I18n.t('repositories.vhf_dsc_controllerreceiver_dsc_3000'), '300'],
      [I18n.t('repositories.watch_receiver_debeg_2150'), '301'],
      [I18n.t('repositories.antenna_coupler'), '302'],
      [I18n.t('repositories.antenna_arrangement'), '303'],
      [I18n.t('repositories.natex_receiver_rx_518'), '304'],
      [I18n.t('repositories.radio_facsimile_rx_debeg_2952'), '305'],
      [I18n.t('repositories.hf_manpack_transceiver_prm_4790a'), '306'],
      [I18n.t('repositories.headset'), '307'],
      [I18n.t('repositories.vhf_fm_manpack_transceiver_prm_4790a'), '308'],
      [I18n.t('repositories.vhm_hand_held_transceiver_prm_4720b'), '309'],
      [I18n.t('repositories.vhm_hand_held_transceiver_prm_6701'), '310'],
      [I18n.t('repositories.emergency_radar_transponder_debeg_5900'), '311'],
      [I18n.t('repositories.emergency_beacon'), '312'],
      [I18n.t('repositories.hf_transmitter_subsystem'), '313'],
      [I18n.t('repositories.1kw_hf_transceiver_1510'), '314'],
      [I18n.t('repositories.180w_hf_transceiver_300'), '315'],
      [I18n.t('repositories.vlflfhf_receiver_subsystem'), '316'],
      [I18n.t('repositories.vhfuhf_transceiver_subsystem'), '317'],
      [I18n.t('repositories.audio_distribution_subsystem'), '318'],
      [I18n.t('repositories.message_handling_subsystem'), '319'],
      [I18n.t('repositories.remote_control_subsystem'), '320'],
      [I18n.t('repositories.gmdss_subsystem'), '321'],
      [I18n.t('repositories.vhf_direction_finder_subsystem'), '322'],
      [I18n.t('repositories.sound_powered_telephone_system'), '323'],
      [I18n.t('repositories.user_station_ust'), '324'],
      [I18n.t('repositories.main_broadcast_system'), '325'],
      [I18n.t('repositories.automatic_telephone_system'), '326'],
      [I18n.t('repositories.loudhailer_system'), '327']]],
    [I18n.t('repositories.domestic_equipment'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.ice_cube_maker'), '328'],
      [I18n.t('repositories.drinking_water_chiller'), '329'],
      [I18n.t('repositories.refrigerator'), '330'],
      [I18n.t('repositories.provision_food_lift'), '331'],
      [I18n.t('repositories.provision_food_lift_motor'), '332'],
      [I18n.t('repositories.provision_food_lift_motor_starter'), '333'],
      [I18n.t('repositories.refrigerator'), '334'],
      [I18n.t('repositories.electric_galley_range'), '335'],
      [I18n.t('repositories.electric_deep_fryer'), '336'],
      [I18n.t('repositories.electric_boiling_kettle'), '337'],
      [I18n.t('repositories.electric_tiltable_frying_pan'), '338'],
      [I18n.t('repositories.garbage_waste_compactor'), '339'],
      [I18n.t('repositories.washing_machine'), '340'],
      [I18n.t('repositories.drying_tumbler'), '341'],
      [I18n.t('repositories.baking_oven'), '342'],
      [I18n.t('repositories.baking_equipment'), '343'],
      [I18n.t('repositories.coffee_machine'), '344'],
      [I18n.t('repositories.food_waste_disposer'), '345'],
      [I18n.t('repositories.electric_meat_slicer'), '346'],
      [I18n.t('repositories.ships_recreation_equipment_sre'), '347'],
      [I18n.t('repositories.closed_circuit_television'), '348']]],
    [I18n.t('repositories.ship_monitoring'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.ship_monitoring_system'), '349']]],
    [I18n.t('repositories.degaussing'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.degaussing_control_unit'), '350'],
      [I18n.t('repositories.power_distribution_centre'), '351'],
      [I18n.t('repositories.degaussing_power_supply_unit'), '352'],
      [I18n.t('repositories.tripple_probe'), '353'],
      [I18n.t('repositories.probe_connection_box'), '354'],
      [I18n.t('repositories.terminal_box'), '355']]],
    [I18n.t('repositories.workshop_machinery'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.lathe_machine'), '356'],
      [I18n.t('repositories.pedestal_drilling_machine'), '357'],
      [I18n.t('repositories.bench_drilling_machine'), '358'],
      [I18n.t('repositories.drilling_machine'), '359'],
      #bench_drilling_machine
      [I18n.t('repositories.grinding_machine'), '360'],
      [I18n.t('repositories.welding_rectifier'), '361']
      #pedestal_drilling_machine
      #lathe_machine
      #drilling_machine
      ]],
    [I18n.t('repositories.stabilising_pump'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.intering_stabilizer_plant'), '362'],
      [I18n.t('repositories.stabilising_tank'), '363'],
      [I18n.t('repositories.stabilising_plant'), '364']]],
    [I18n.t('repositories.diving_facility'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.diving_air_compressor'), '365'],
      [I18n.t('repositories.diving_air_compressor_motor'), '366']]],
    [I18n.t('repositories.sanitary_and_drainage'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.sewage_treatment_plant'), '367'],
      [I18n.t('repositories.sewage_pump'), '368'],
      [I18n.t('repositories.sewage_pump_motor'), '369'],
      [I18n.t('repositories.sewage_metering_pump_motor'), '370'],
      [I18n.t('repositories.sewage_driving_water_pump_motor'), '371'],
      [I18n.t('repositories.ejector'), '372'],
      [I18n.t('repositories.sewage_treatment_switchboard'), '373'],
      [I18n.t('repositories.sewage_aeration_blower'), '374'],
      [I18n.t('repositories.oily_water_separator'), '375'],
      [I18n.t('repositories.grey_water_pump'), '376'],
      [I18n.t('repositories.grey_water_pump_motor'), '377'],
      [I18n.t('repositories.sanitary_system_and_fittings'), '378'],
      [I18n.t('repositories.waste_detergent_tank'), '379'],
      [I18n.t('repositories.waste_water_tank'), '380'],
      [I18n.t('repositories.bilge_water_tank'), '381']]],
    [I18n.t('repositories.boats'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.whaler'), '382'],
      [I18n.t('repositories.dinghy'), '383']]],
    [I18n.t('repositories.special_tools_test'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.special_tools_test_equipments'), '384']]],
    [I18n.t('repositories.surveyhydrographic'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.surveyhydrographic_equipment_system'), '385']]],
    [I18n.t('repositories.cathodic_protection'), 
     [[I18n.t('select'),''],
      [I18n.t('repositories.cathodic_protection'), '386'],
      [I18n.t('repositories.zinc_anode'), '387']]]]
  end
  
  def self.document_classification
    [[I18n.t('repositories.restricted'), '1'],
     [I18n.t('repositories.confidential'), '2'],
     [I18n.t('repositories.secret'), '3']
     ]
  end
  
  def self.vessel_classes
    [['Frigate', '1'],
     ['Corvette', '2'],
     ['Patrol Vessel', '3'],
     ['Multi Purpose Support Ship', '4'],
     ['Mine Counter Measure Vessels', '5'],
     ['Others', '6']]
  end
 
  def self.vessel_list
    [
     ['Frigate', [[I18n.t('select'),''], ['KD Jebat', '1'], ['KD Lekiu', '2']]], 
     ['Corvette',[[I18n.t('select'),''], ['KD Kasturi', '3'], ['KD Lekir', '4']]], 
     ['Patrol Vessel', [[I18n.t('select'),''], ['KD Pahang', '5'], ['KD Kelantan', '6'], ['KD Selangor', '7'], ['KD Terengganu', '8'],['KD Kedah', '9'], ['KD Perak', '10']]], 
     ['Multi Purpose Support Ship', [[I18n.t('select'),''], ['KD Mahawangsa', '11']]], 
     ['Mine Counter Measure Vessels', [[I18n.t('select'),''], ['KD Mahameru', '12'], ['KD Ledang', '13'], ['KD Kinabalu', '14'], ['KD Jerai', '15']]],
     ['Others', [[I18n.t('select'),''], ['KLD Tunas Samudera', '16'],['KD Perantau', '17'], ['KD Mutiara', '18']]]
     ]
  end
  
  def self.vessel_list2
    [
     ['Frigate', ['KD Jebat', 'KD Lekiu']], 
     ['Corvette',['KD Kasturi', 'KD Lekir']], 
     ['Patrol Vessel', ['KD Pahang', 'KD Kelantan', 'KD Selangor', 'KD Terengganu', 'KD Kedah', 'KD Perak']], 
     ['Multi Purpose Support Ship', ['KD Mahawangsa']],
     ['Mine Counter Measure Vessels', ['KD Mahameru', 'KD Ledang', 'KD Kinabalu', 'KD Jerai']],
     ['Others', ['KLD Tunas Samudera', 'KD Perantau', 'KD Mutiara']]
     ]
  end

  def self.vessel_class_names
    [ ['KD Jebat', 'KD Lekiu'], ['KD Kasturi', 'KD Lekir'], ['KD Pahang', 'KD Kelantan', 'KD Selangor', 'KD Terengganu', 'KD Kedah','KD Perak'],['KD Mahawangsa'],['KD Mahameru', 'KD Ledang', 'KD Kinabalu', 'KD Jerai'], ['KLD Tunas Samudera', 'KD Perantau', 'KD Mutiara']]
  end
  
  def self.vessel_names
    Repository.vessel_class_names.flatten
  end
  
  def render_document
    (Repository.document.find_all{|disp, value| value == document_type }).map {|disp, value| disp}[0]
  end
  
  def render_subdocument
    (Repository.subdocument.find_all{|disp, value| value == document_subtype }).map {|disp, value| disp}[0]
  end
  
  #temporary 11May2017 - remove upon completion of updates for document_subtype (document_group) - note : 209 (118 records)
  def render_subdocument_old
    (Repository.subdocument_old.find_all{|disp, value| value == category.to_s }).map {|disp, value| disp}[0]
  end
  
  def render_equipment
    #list=Repository.equipment_list.map{|x,y|y.each{|a|a}}  #Repository.equipment_list.map{|x,y|y}
    ls=[]
    Repository.equipment_list.each do |x, y|
      y.each do |a|
	ls << a 
      end
    end
    ls
    (ls.find_all{|disp, value| value==equipment}).map{|disp, value| disp}[0]
  end
  
  def render_classification
    (Repository.document_classification.find_all{|disp, value|value==classification}).map {|disp, value| disp}[0]
  end
  
  def render_vessel_class
    (Repository.vessel_classes.find_all{|disp, value|value==vessel_class}).map {|disp, value| disp}[0]
  end
  
  def render_vessel 
    (Repository.vessel_list[(vessel_class.to_i)-1][1].find_all{|d,v|v==vessel}).map{|d,v|d}[0]
    #(Repository.vessel_list.find_all {|disp, value| value==vessel}).map {|disp, value| disp}[0]
  end
  
  #usage - repositorysearches/_form
  def self.vessel_exist_documents
    vmaster_spec=[]
    vspecific=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.each do |vesselclass_no, repos|
      index=vesselclass_no.to_i-1
      vesselclass_str=Repository.vessel_classes[index][0]
      vessel_ofclass_str=Repository.vessel_class_names[index]
      a=0
      for repo in repos
        if repo.vessel.blank? 
          if a==0 
            vmaster_spec << [vesselclass_str, vessel_ofclass_str]    #retrieve vessel_class c/w vessels of vessel_class (hv master document)
            a+=1
          end
        else
          vspecific << [vesselclass_str, [repo.render_vessel]]
        end
      end
    end
    vspecific.uniq.each{|cc| vmaster_spec << cc if vmaster_spec.map{|x,y|x}.include?(cc[0]) == false} #combine vessel_class c/w ONE vessel (hv specific document)
    
    #sort list as per vessel_classes
    #http://stackoverflow.com/questions/31398239/need-to-sort-array-based-on-another-array-of-array
    b=Repository.vessel_classes.map{|x|x[0]}
    vmaster_spec.sort{|x,y|b.index(x.first) <=> b.index(y.first)}
  end
  
  #usage - repositorysearches/_form
  def self.doctype_per_vessel
    ab=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.sort.each do |vessel_class, repositories|   #vessel_class ===> "1"
      for a_vessel in Repository.vessel_list2[vessel_class.to_i-1][1]
        a=[]
        for repository in repositories
          unless repository.vessel.blank? #specific
            a << [repository.render_document, repository.document_type] if repository.render_vessel==a_vessel
          else #master
            a << [repository.render_document, repository.document_type] if repository.vessel_class==vessel_class
          end
        end
        aa=[[I18n.t('select'), ""]]+a.uniq.sort
        ab << [a_vessel, aa] if aa.count > 1 #(including 'select')
      end
    end
    ab
  end
  
  #usage - repositorysearches/_form
  def self.docsubtype_per_doctype
    ab=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.sort.each do |vessel_class, repositories|
      for a_vessel in Repository.vessel_names
        repositories.group_by(&:document_type).each do |dt, rs|
          a=[[I18n.t('select'), ""]]
          for repository in rs
            unless repository.vessel.blank? #specific
              a << [repository.render_subdocument, repository.document_subtype] if repository.render_vessel==a_vessel && dt==repository.document_type
            else #master
              a << [repository.render_subdocument, repository.document_subtype] if dt==repository.document_type
            end
          end
          ab << [a_vessel+": "+((Repository.document.find_all{|disp, value| value == dt }).map {|disp, value| disp}[0]), a.uniq]
        end 
      end
    end
    ab
  end
 
  #usage - repositorysearches/_form --> display list based on current saved records only
  def self.equipment_per_docsubtype
    ab=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.sort.each do |vessel_class, repositories|
        repositories.group_by(&:document_subtype).each do |dst, rs|
          a=[[I18n.t('select'), ""]]
          rs.group_by(&:vessel).each do |ves, repos|
            for repository in repos
              a << [repository.render_equipment, repository.equipment]
            end
          end
          ab << [((Repository.subdocument.find_all{|disp, value| value == dst }).map {|disp, value| disp}[0]), a.uniq]
        end
    end
    ab
  end
  
end
