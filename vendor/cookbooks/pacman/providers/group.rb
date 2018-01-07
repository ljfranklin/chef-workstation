#
# Cookbook Name:: pacman
# Provider:: group
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :install do
  unless @pmgroup.exists
    shell_out(
      "pacman --sync --noconfirm --noprogressbar#{expand_options(@new_resource.options)} #{@new_resource.name}"
    ).run_command.error!
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  if @pmgroup.exists
    shell_out(
      "pacman --remove --noconfirm --noprogressbar#{expand_options(@new_resource.options)} #{@new_resource.name}"
    ).run_command.error!
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @pmgroup = Chef::Resource.resource_for_node('pacman_group', node).new(@new_resource.name)

  Chef::Log.debug("Checking pacman for #{@new_resource.package_name}")
  p = shell_out("pacman -Qg #{@new_resource.package_name}")
  exists = p.stdout.include?(@new_resource.package_name)
  @pmgroup.exists(exists)
end

# From Chef::Provider::Package
def expand_options(options)
  options ? " #{options}" : ""
end
