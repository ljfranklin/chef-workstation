module GsettingsHelper
  def self.set_gsetting(plugin, key, value)
    "gsettings set \"#{plugin}\" \"#{key}\" \"#{value}\""
  end

  def self.gsetting_unchanged?(plugin, key, value)
    "test \"$(gsettings get \"#{plugin}\" \"#{key}\")\" = \"#{value}\""
  end
end
