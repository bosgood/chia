FROM python:3.7

RUN apt-get install -y git

# Download chia-blockchain from Github
RUN git clone https://github.com/Chia-Network/chia-blockchain.git \
  -b latest \
  --recurse-submodules \
  /usr/local/chia-blockchain
RUN cd /usr/local/chia-blockchain
WORKDIR /usr/local/chia-blockchain

# Setup Python virtualenv and additional dependencies
ENV VIRTUAL_ENV=/usr/local/chia-blockchain/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3 -m venv $VIRTUAL_ENV && \
  pip install --upgrade pip && \
  pip install wheel && \
  pip install --extra-index-url https://pypi.chia.net/simple/ miniupnpc==2.1 && \
  pip install -e . --extra-index-url https://pypi.chia.net/simple/

COPY ./entrypoint.sh .
CMD [ "bash", "/usr/local/chia-blockchain/entrypoint.sh" ]
