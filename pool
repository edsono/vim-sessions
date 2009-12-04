declare pkg_name=sessions
declare pkg_base=$(dirname "$0")
declare pkg_version=$(git tag | sort | tail -n 1)
declare pkg_file="${pkg_name}-${pkg_version#v}.vba"
declare prefix=".vim"

function vimball {
  printf "* %-40s " "Creating vimball package"
  vim ".pkgfiles" +":%MkVimball! ${pkg_file} ." +":q" &> /dev/null
  printf "done\n"

  return 0
}

function compress {
  printf "* %-40s " "Compressing package ${pkg_file}"
  gzip ${pkg_file} &> /dev/null
  printf "done\n"

  return 0
}

function install {
  vimball
  printf "* %-40s " "Intalling ${pkg_file}"
  vim ${pkg_file} +":source %" +":q" &> /dev/null
  printf "done\n"

  return 0
}

function package {
  test -f ${pkg_file}   && rm ${pkg_file}
  vimball
  test -f ${pkg_file}.* && rm ${pkg_file}.*
  compress
}

function doc {
  printf "* %-40s " "Building documentation"
  markdown -f toc -T -o README.html README.mkd &> /dev/null
  printf "done\n"

  return 0
}

function news {
  for remote in github codaset; do
    printf "* %-40s " "Pushing news to ${remote}"
      git push $remote news &> /dev/null
    printf "done\n"
  done
}

function version {
  test -z $1 && {
    echo "version number is required"
    exit 1
  }
  test -f release.tmp && {
    git tag -a -s ${1} -F release.tmp
  } || {
    echo "release.tmp is required"
    exit 1
  }
}

function release {
  for remote in $(git remote); do
    printf "* %-40s " "Pushing release to ${remote}"
      git push --tags $remote master &> /dev/null
    printf "done\n"
  done
}

test $# -eq 0 && {
  echo "Arguments required"
  exit 1
}

${@}

# vim: filetype=sh

