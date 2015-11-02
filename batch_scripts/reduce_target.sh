#!/bin/bash

# reduce_target.sh to reduce a complete project in batch with CRUSH
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

if [ -z "$1" ];
    then
    echo "WW - No input source list using 'target_sources' as default"
    infile='target_sources'
    else
    infile=$1
fi

source config.sh

if [ ! -e $LIST_DIR/$infile ];
    then
    echo "EE - Cannot found target list please check"
    echo "EE - $LIST_DIR/$infile"
    exit -1
fi

for source_name in $(cat $LIST_DIR/$infile | awk '{ print $1}')
  do
  $SCRIPT_DIR/reduce_source.sh $source_name 
done

exit 0

