#!/usr/bin/env bash

if [ -f /runner/project/requirements.txt ];
then 
  pip3 install --user -r /runner/project/requirements.txt
fi

if [ -f /runner/project/requirements.yml ];
then 
  ansible-galaxy role install -r /runner/project/requirements.yml
  ansible-galaxy collection install -r /runner/project/requirements.yml
fi

ansible-runner run -p "$RUNNER_PLAYBOOK" /runner