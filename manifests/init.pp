# Class: Python
#
# Installs python from source. Needs the puppet-archive module.
#
# Usage:
# include python
# Or:
# class { python: version => x.x.x }

class python( $version = "2.7" ) {
  archive { "python-${version}":
    url => "http://python.org/ftp/python/${version}/Python-${version}.tgz",
    target => "/usr/local/src",
    src_target => "/usr/local/src",
    checksum => false,
  }

  exec { "configure python ${version}":
    cwd     => "/usr/local/src/Python-${version}",
    command => "/bin/sh -c './configure'",
    require => Archive["python-${version}"],
    alias   => "conf_python_${version}",
  }

  exec { "make && make install for python ${version}":
    cwd     => "/usr/local/src/Python-${version}",
    command => "make && make install",
    require => Exec["conf_python_${version}"],
    alias   => "install_python_${version}"
  }

  exec { "move a possible already installed version of python":
    onlyif => "test ! -L /usr/bin/python",
    command => "mv /usr/bin/python /usr/bin/python`python -V 2>&1 | cut -d ' ' -f 2`"
  }

  file { "/usr/bin/python":
    ensure => link,
    target => "/usr/local/bin/python${version}",
    force  => true,
    require => Exec["install_python_${version}"],
  }
}
