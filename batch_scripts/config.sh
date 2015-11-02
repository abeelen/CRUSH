#!/bin/bash

# config.sh setup the path for batch reduction with CRUSH
# Copyright (C) 2004 Alexandre Beelen
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#

# Needed for java to work
export LC_ALL=en_EN

# Where crush is installed
export CRUSH_DIR=$HOME/Observatory/CSO/crush

# Where the sources list will be (also place for the target_sources file)
export LIST_DIR=$HOME/Projects/Survey/2004_QSOs_CSO/list

# Where you want to have the reduced scans
export DATA_DIR=$HOME/Projects/Survey/2004_QSOs_CSO/data

# Where you installed those scripts file
export SCRIPT_DIR=$HOME/Projects/Survey/2004_QSOs_CSO/scripts

# Where are the raw data.
export RAW_DIR=$HOME/data/CSO/data_2004jan/pool

# Option to be passed to crush
export crush_option='-deep -compact'
