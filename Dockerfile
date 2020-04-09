FROM python:3.7-slim-stretch

# Install python-dev default-libmysqlclient-dev in order to install mysqlclient(MySQLdb for py3)
RUN \
	DEBIAN_FRONTEND=noninteractive \
	\
	set -ex; \
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get -q -y update && \
	apt-get install -q -y --no-install-recommends gcc python3-dev default-libmysqlclient-dev; \
	\
	pip install --no-cache-dir flup==1.0.3 wxpy==0.3.9.8 web.py==0.51 requests emoji pyyaml redis mysqlclient pymongo; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*;

# libmysqlclient and related packages have been removed above,
# Reinstall default-libmysqlclient-dev, otherwise, MySQLdb(mysqlclient) will not be available
# Install fcgiwrap and flup to support FastCGI
RUN apt-get update; \
	apt-get install -q -y --no-install-recommends default-libmysqlclient-dev fcgiwrap; \
	\
	rm -rf /var/lib/apt/lists/*;

WORKDIR /
