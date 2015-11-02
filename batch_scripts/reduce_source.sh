#!/bin/bash

# reduce_source.sh to reduce a source with CRUSH
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
    echo "EE - You should provide the source name"
    exit -1
fi

source config.sh

if [ ! -e $LIST_DIR/$1".list" ];
    then
    echo "EE - Cannot found scan list please check"
    echo "EE - $LIST_DIR/$1.list"
    exit -1
fi


cd $CRUSH_DIR

# Reduce the source
cat $LIST_DIR/$1".list" | xargs nice -19 ./crush $scan $crush_option -outpath=$DATA_DIR -name=$1".fits"

# To correct an old bug of CRUSH
if [ -z $1".fits" ]
then 
    mv $1".fits" $DATA_DIR
fi

exit 0

