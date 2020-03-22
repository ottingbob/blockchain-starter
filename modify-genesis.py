#!/usr/bin/python3

import os
import sys

# Get these from command line
# authAccount = "254039c799ebf89f9ee711919b6caa71e563ffff"
# fundAccount = "254039c799ebf89f9ee711919b6caa71e563dddd"
authAccount = sys.argv[1]
fundAccount = sys.argv[2]

auth_account_placeholder = "AUTH_ADDRESS_HERE"
fund_account_placeholder = "FUND_ADDRESS_HERE"

# open file
input_genesis = open('base-genesis.json')

# iterate over file and change the stuff
contents = input_genesis.read() \
  .replace(auth_account_placeholder, authAccount) \
  .replace(fund_account_placeholder, fundAccount)

input_genesis.close()

# print(contents)

# save file
out_genesis = 'genesis.json'
with open(out_genesis, 'w') as f:
  f.write(contents)

print('Added account [{0}]'.format(authAccount))
print('Added account [{0}]'.format(fundAccount))
print('Completed and successfully written to genesis.json')
