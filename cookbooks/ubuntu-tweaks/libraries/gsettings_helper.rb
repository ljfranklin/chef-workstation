module GsettingsHelper
  def self.set_gsetting(plugin, key, value)
    <<-EOH
    gsettings set \
    #{plugin} \
    #{key} #{value}
    EOH
  end

  def self.gsetting_unchanged?(plugin, key, value)
    <<-EOH
    VALUE=$(gsettings get #{plugin} #{key})
    if [ "${VALUE}" = "#{value}" ]; then
      exit 0
    fi
    exit 1
    EOH
  end
end
