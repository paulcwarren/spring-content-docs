pushd ~/git/spring-content
  git co gh-pages
  git clean -ffd

  pushd ~/git/spring-content-docs
    mkdocs build --clean
  popd

  cp -R ~/git/spring-content-docs/site/* .

pushd
