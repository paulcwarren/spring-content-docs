#! /bin/bash

author=$(git config --get user.name)
if [ "$author" != "Paul Warren" ]
  then
    echo "git author not set ('git solo pw')"
    exit 1
fi

pwd=$PWD

mkdocs build --clean

tmpdir=`mktemp -d 2>/dev/null || mktemp -d -t 'sctmpdir'`
mkdir -p $tmpdir

git clone https://github.com/paulcwarren/spring-content $tmpdir
pushd $tmpdir
  git checkout gh-pages
  cp -R $pwd/site/* .
  git add .
  git commit -m "Docs update"
  git pull -r
  git push origin gh-pages 
popd

rm -rf $tmpdir
