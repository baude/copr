#!/bin/sh
# https://docs.pagure.org/copr.copr/custom_source_method.html#custom-source-method

mkdir -p results
resultdir=$(readlink -f results)
set -x
set -e

git clone https://github.com/containernetworking/plugins
cd plugins

COMMIT=$(git rev-parse HEAD)
COMMIT_SHORT=$(git rev-parse --short HEAD)
COMMIT_NUM=$(git rev-list HEAD --count)
COMMIT_DATE=$(date --date="@$(git show -s --format=%ct HEAD)" +%Y%m%d)

git archive --prefix "cni-${COMMIT_SHORT}/" --format "tar.gz" HEAD -o "${resultdir}/cni-${COMMIT_SHORT}.tar.gz"
cd ../

curl -O ${resultdir}/cni.spec.in https://raw.githubusercontent.com/baude/copr/master/cni.spec.in

sed "s,#COMMIT#,${COMMIT},;
     s,#SHORTCOMMIT#,${COMMIT_SHORT},;
     s,#COMMITNUM#,${COMMIT_NUM},;
     s,#COMMITDATE#,${COMMIT_DATE}," \
         ${resultdir}/cni.spec.in > ${resultdir}/cni.spec

