# FROM ubuntu:19.04
FROM ubuntu:19.10

RUN apt-get update && \
  dpkg --configure -a && \
  apt-get install --reinstall python-minimal \
    python3-software-properties python-lockfile -y && \
  apt-get install software-properties-common -y && \
  add-apt-repository -y ppa:ethereum/ethereum && \
  apt-get install ethereum -y

ENV PASS=__Y0u_w!lL_N3v3r_g34_4hI5__

WORKDIR /app
COPY base-genesis.json modify-genesis.py ./

# PASS needs to be the password which is interpreted as reading from
# a file for the password argument... the output should be as follows below
RUN echo $PASS > pass && \
  # Create authority account
  geth --datadir ~/.ethereum/ account new --password pass >> auth.txt && \
  # Create transaction account -- prefunded to send transactions
  geth --datadir ~/.ethereum/ account new --password pass >> fund.txt && \
  # strip out the account and remove the 0x from the front
  # create env vars, run python script to create genesis
  cat auth.txt | grep -e key: | sed 's/.* //' | cut -c 3- > auth_account && \
  cat fund.txt | grep -e key: | sed 's/.* //' | cut -c 3- > fund_account && \
  python modify-genesis.py $(cat auth_account) $(cat fund_account) && \
  # Initialize the chain dir with the genesis block
  geth --datadir ~/.ethereum/ init genesis.json && \
  # Create teh auth address to unlock when starting the chain
  cat auth.txt | grep -e key: | sed 's/.* //' >> auth_addr

EXPOSE 8545
EXPOSE 30303

CMD geth --nodiscover --networkid 42 --datadir ~/.ethereum/ --unlock $(cat auth_addr) \
  --password pass --mine --rpc --rpcport 8545 --rpcaddr 0.0.0.0 \
  --rpcapi eth,net,web3,personal --allow-insecure-unlock
