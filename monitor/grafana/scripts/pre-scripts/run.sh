#!/bin/bash
set -x
git clone https://github.com/percona/grafana-dashboards.git /var/lib/grafana/grafana-dashboards && \
cp /var/lib/grafana/grafana-dashboards/misc/* /var/lib/grafana/grafana-dashboards/dashboards/
ls -Al /var/lib/grafana/grafana-dashboards/dashboards
