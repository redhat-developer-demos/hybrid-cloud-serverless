#!/usr/bin/env bash

ansible localhost -c local -m get_url -a "url=https://raw.githubusercontent.com/kameshsampath/ansible-role-openshift-spices/master/requirements.txt dest=/tmp/requirements.txt"

ansible localhost -c local -m get_url -a "url=https://raw.githubusercontent.com/kameshsampath/ansible-role-openshift-spices/master/requirements.yml dest=/tmp/requirements.yml"

pip3 install --user -r /tmp/requirements.txt

ansible-galaxy role install -r /tmp/requirements.yml

ansible-galaxy collection install -r /tmp/requirements.yml

ansible-runner run -p serverless_with_pipelines.yml /runner