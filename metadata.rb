name             "java_demo"
maintainer       "Tim Green"
maintainer_email "tgreen@opscode.com"
license          "All rights reserved"
description      "Standalone java demo."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends          "apt", "~> 1.9.2"
depends          "tomcat", "~> 0.12.0"
depends          "mysql", "~> 3.0.0"
depends          "database", "~> 1.3.12"
depends          "application", "~> 2.0.2"
depends          "application_java", "~> 1.1.0"
