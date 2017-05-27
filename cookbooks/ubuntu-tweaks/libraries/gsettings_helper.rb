module GsettingsHelper
  def get_gsetting(plugin, key)
    "gsettings get \"#{plugin}\" \"#{key}\""
  end

  def set_gsetting(plugin, key, value)
    "gsettings set \"#{plugin}\" \"#{key}\" \"#{value}\""
  end

  def gsetting_unchanged?(plugin, key, value)
    "test \"$(gsettings get \"#{plugin}\" \"#{key}\")\" = \"#{value}\""
  end
end
