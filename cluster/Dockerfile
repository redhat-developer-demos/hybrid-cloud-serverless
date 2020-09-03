FROM docker.io/ansible/ansible-runner

ADD project/requirements.txt /runner/project/requirements.txt
ADD project/requirements.yml /runner/project/requirements.yml

RUN dnf -y install git \
  && pip3 install --user -r /runner/project/requirements.txt \
  && ansible-galaxy role install -r /runner/project/requirements.yml \
  && ansible-galaxy collection install -r /runner/project/requirements.yml \
  && dnf -y clean all

ENTRYPOINT ["entrypoint"]

CMD ["ansible-runner","run","-p","playbook.yml","/runner"]