#!/bin/sh

#=============================================================================
#
# puppet-apply.sh
# ---------------
#
# A wrapper script to make sure Puppet always runs in exactly the way I
# want it to.
#
# R Fisher 08/2014
#
#=============================================================================

PATH=/opt/local/bin:/opt/puppet/bin:/bin:/usr/bin:/usr/sbin:/sbin:/opt/local/ruby/bin

BASE=`dirname $0`

cd $BASE

FACTERLIB="${BASE}/facts"

export FACTERLIB

/opt/local/ruby/bin/puppet apply \
    --modulepath=modules:vendor/modules \
    --hiera_config=${BASE}/hiera.yaml \
    --verbose \
    manifests/site.pp
