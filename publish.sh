#! /bin/bash

mkdoc build --clean
pushd ../spring-content
  git stash
  git co gh-pages
  git clean -ffd
  cp -R ../spring-content-docs/site/* .
  git add .
  git ci -m "Docs update"
  git pull -r
  git push origin gh-pages 
  git co master
  git stash pop
popd

