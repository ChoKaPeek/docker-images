#!/bin/bash
service nginx start

# run as non-root
su elasticsearch -c /opt/elasticsearch/bin/elasticsearch
