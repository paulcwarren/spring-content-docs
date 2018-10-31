#! /bin/bash

author=$(git config --get user.name)
if [ "$author" != "Paul Warren" ]
  then
    echo "git author not set ('git solo pw')"
    exit 1
fi

mkdocs build --clean
pushd ../spring-content
  git stash
  git checkout gh-pages
  git clean -ffd
  cp -R ../spring-content-docs/site/* .
  git solo pw
  git add .
  git commit -m "Docs update"
  git pull -r
  git push origin gh-pages 
  git checkout master
  git stash pop
popd

