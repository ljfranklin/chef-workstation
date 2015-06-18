def relative_path(dir)
  File.expand_path(File.join(File.dirname(__FILE__), '..', dir))
end

cookbook_path [
  relative_path('cookbooks'),
  relative_path('vendor/cookbooks')
]
role_path relative_path('roles')
environment_path relative_path('environment')
data_bag_path relative_path('data_bags')
encrypted_data_bag_secret relative_path('secrets/my_secret_key')
