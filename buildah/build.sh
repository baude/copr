#!/bin/sh
# https://docs.pagure.org/copr.copr/custom_source_method.html#custom-source-method

set -x
set -e

mkdir -p results
resultdir=$(readlink -f results)

package=buildah
clone_url=https://github.com/projectatomic/buildah

git clone ${clone_url}
cd buildah

COMMIT=$(git rev-parse HEAD)
COMMIT_SHORT=$(git rev-parse --short HEAD)
COMMIT_NUM=$(git rev-list HEAD --count)
COMMIT_DATE=$(date +%s)
TARBALL="${resultdir}/buildah-${COMMIT_SHORT}.tar.gz"

git archive --prefix "${package}-${COMMIT_SHORT}/" --format "tar.gz" HEAD -o "${TARBALL}"

curl -o ${resultdir}/${package}.spec.in https://raw.githubusercontent.com/baude/copr/master/${package}/${package}.spec.in

sed "s,#COMMIT#,${COMMIT},;
     s,#SOURCE#,${TARBALL},;
     s,#SHORTCOMMIT#,${COMMIT_SHORT},;
     s,#COMMITNUM#,${COMMIT_NUM},;
     s,#COMMITDATE#,${COMMIT_DATE}," \
         ${resultdir}/${package}.spec.in > ${resultdir}/${package}.spec

