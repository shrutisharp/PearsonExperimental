#
# Sonar, entreprise quality control tool.
# Copyright (C) 2008-2013 SonarSource
# mailto:contact AT sonarsource DOT com
#
# SonarQube is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# SonarQube is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

#
# Sonar 3.0
#
class AddIndicesToResourceIndex < ActiveRecord::Migration

  class ResourceIndex < ActiveRecord::Base
    set_table_name 'resource_index'
  end

  def self.up
    ResourceIndex.reset_column_information

    begin
      if dialect=='mysql'
        # Index of varchar column is limited to 767 bytes on mysql (<= 255 UTF-8 characters)
        # See http://jira.codehaus.org/browse/SONAR-4137 and
        # http://dev.mysql.com/doc/refman/5.6/en/innodb-restrictions.html
        add_index 'resource_index', 'kee', :name => 'resource_index_key', :length => 255
      else
        add_index 'resource_index', 'kee', :name => 'resource_index_key'
      end
    rescue
      #ignore, already exists
    end
    begin
      add_index 'resource_index', 'resource_id', :name => 'resource_index_rid'
    rescue
      #ignore, already exists
    end
  end
end
