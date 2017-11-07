FROM fnndsc/ubuntu-python3

COPY ./keystore/deploy_key /root/deploy_key

WORKDIR /root
ENV GIT_SSH_COMMAND="ssh -i /root/deploy_key -o StrictHostKeyChecking=no"
RUN apt-get update && apt-get install -y git build-essential python3-dev libssl-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev libpq-dev
RUN git clone git@github.com:GalacticExchange/gex_blockchain_tools.git
RUN pip3 install greenlet && pip3 install gevent && pip3 install -r /root/gex_blockchain_tools/requirements.txt

ENV PYTHONPATH="/root/gex_blockchain_tools/micro_payments:/root/gex_blockchain_tools/"

ENTRYPOINT ""
CMD "python3"

