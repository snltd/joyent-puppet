#!/bin/ksh

PATH=/opt/local/bin:/opt/puppet/bin:/bin:/usr/bin:/usr/sbin:/sbin:/opt/local/ruby/bin

BASE=`dirname $0`
cd $BASE
mount | grep -q $BASE || /opt/local/bin/git pull

export FACTERLIB="${BASE}/facts"

/opt/local/ruby/bin/puppet apply \
    --config=./puppet.conf \
    --modulepath=modules:vendor/modules \
	--environmentpath=${BASE}/environments \
    --hiera_config=${BASE}/hiera.yaml \
    --verbose \
    manifests/site.pp
