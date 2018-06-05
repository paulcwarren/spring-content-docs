#! /bin/bash

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

