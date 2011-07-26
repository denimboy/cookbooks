maintainer       "Dennis Watson"
maintainer_email "cookbooks@brainamp.com"
license          "All rights reserved"
description      "Build postgres from source, install and configure."
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe            "postgresql::default", "Does nothing."
recipe            "postgresql::source", "Installs postgresql from source."

attribute "postgres/version",
  :display_name => "Postgres version",
  :description => "Which version of postgres will be installed.",
  :required => "optional",
  :default => "8.4.4",
  :recipes => ["postgresql::source"]

attribute "postgres/basedir",
  :display_name => "Postgres basedir",
  :description => "Base directory where postgres will be installed.",
  :required => "optional",
  :default => "/opt/postgres",
  :recipes => ["postgresql::source"]

attribute "postgres/dba",
  :display_name => "Postgres DBA user",
  :description => "Admin user for postgres database.",
  :required => "optional",
  :default => "postgres",
  :recipes => ["postgresql::source"]

attribute "postgres/port",
  :display_name => "Postgres default network port",
  :description => "Default port for postgres server.",
  :required => "optional",
  :default => "5432",
  :recipes => ["postgresql::source"]
