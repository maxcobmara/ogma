module AssetDefectsHelper
  
  def processtype
      processtype=I18n.t('asset.defect.repair') if process_type == 'repair'
      processtype=I18n.t('asset.defect.dispose') if process_type == 'dispose'
      processtype
  end
  
  def exist_count
    AssetDefect.where(asset_id:asset_id).count
  end
  
   def marked_dispose
    AssetDefect.where('asset_id=? and process_type=?', asset_id,'dispose')
  end
  
  def marked_dispose_count
    marked_dispose.count
  end
  
  def marked_dispose_inc
    marked_dispose.pluck(:id).include?(id)
  end
  
end