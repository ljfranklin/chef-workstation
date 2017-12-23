#
# Cookbook Name:: pacman
# Resource:: group
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

actions :install

default_action :install

attribute :package_name, :name_attribute => true
attribute :version, :default => nil
attribute :build_dir, :default => node[:pacman][:build_dir]
attribute :build_user, :default => node[:pacman][:build_user]
attribute :build_group, :default => node[:pacman][:build_group]
attribute :install_user, :default => node[:pacman][:install_user]
attribute :install_group, :default => node[:pacman][:install_group]
attribute :options, :kind_of => String
attribute :pkgbuild_src, :default => false
attribute :patches, :kind_of => Array, :default => []
attribute :environment, :kind_of => Hash, :default => {}
attribute :exists, :default => false
attribute :installed_version, :default => nil
attribute :skippgpcheck, :default => false
