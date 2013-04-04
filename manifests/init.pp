# Class: Python
#
# Installs python from source. Needs the puppet-archive module.
#
# Usage:
# include python
# Or:
# class { python: version => x.x.x }

class python( $version = "2.7" ) {
  archive { "Python-${version}":
    url => "http://python.org/ftp/python/${version}/Python-${version}.tgz",
    target => "/usr/local/src",
    src_target => "/usr/local/src",
    checksum => false,
  }

  exec { "configure python ${version}":
    cwd     => "/usr/local/src/Python-${version}",
    command => "/bin/sh -c './configure'",
    require => Archive["Python-${version}"],
    alias   => "conf_python_${version}",
    creates => "/usr/local/src/Python-${version}/Modules/Setup"
  }

  exec { "make && make install for python ${version}":
    cwd     => "/usr/local/src/Python-${version}",
    command => "make && make install",
    require => Exec["conf_python_${version}"],
    alias   => "install_python_${version}"
    creates => "/usr/local/bin/python${version}"
  }

  #exec { "fix yum to use old python version":
    #onlyif => "test -e /usr/bin/python -a ! -L /usr/bin/python",
    #command => "sed -i 's/python\$/python'`/usr/bin/python -V 2>&1 | cut -d ' ' -f 2`'/' /usr/bin/yum || :",
    #alias => "yum_fix_${version}",
  #}

  #exec { "move a possible already installed version of python":
    #command => "mv /usr/bin/python /usr/bin/python`/usr/bin/python -V 2>&1 | cut -d ' ' -f 2`",
    #require => Exec["yum_fix_${version}"]
  #}

  #file { "/usr/bin/python":
    #ensure => link,
    #target => "/usr/local/bin/python${version}",
    #require => Exec["yum_fix_${version}"],
  #}
}
