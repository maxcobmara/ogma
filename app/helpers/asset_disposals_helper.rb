module AssetDisposalsHelper
  
    def disposaltype
      disposetype=I18n.t('asset.disposal.transfer') if disposal_type == 'transfer'
      disposetype=I18n.t('asset.disposal.sold') if disposal_type == 'sold'
      disposetype=I18n.t('asset.disposal.discard') if disposal_type == 'discard'
      disposetype=I18n.t('asset.disposal.stock') if disposal_type == 'stock'
      disposetype=I18n.t('asset.disposal.others') if disposal_type == 'others'
      disposetype
    end
    
    def discardoption
      discardopt=I18n.t('asset.disposal.bury') if discard_options == 'bury'
      discardopt=I18n.t('asset.disposal.burn') if discard_options == 'burn'
      discardopt=I18n.t('asset.disposal.throw') if discard_options == 'throw'
      discardopt=I18n.t('asset.disposal.sink') if discard_options == 'sink'
      discardopt
    end
    
    def total_current_value
      qty*current_value.to_f
    end
    
    def qty
      if (asset.quantity && asset.quantity.to_i>0)
        q=asset.quantity
      else
        q=1
      end
      q
    end
  
end
