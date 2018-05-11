# acl2018_graph2seq
Code for:

"Graph-to-Sequence Learning using Gated Graph Neural Networks"
Daniel Beck, Gholamreza Haffari, Trevor Cohn
ACL 2018

## Requirements

It is highly recommended to use a Python virtual environment for this. The code is based on the Sockeye toolkit for NMT and uses an earlier version of MXNet. We plan to merge the latest Sockeye master branch soon, which uses the last MXNet version but for now we keep those steps for the sake of reproduction.

0) (optional) Install virtualenv and create a new virtual environment. Follow the steps in here:

https://virtualenv.pypa.io/en/stable/

1) Install MXNet 0.10.0

`pip install mxnet==0.10.0`

2) Clone my Sockeye fork:

`git clone https://github.com/beckdaniel/sockeye.git`

3) Change to branch `acl2018` and install Sockeye. Any extra requirements will be installed automatically.

`cd sockeye`
`git checkout acl2018`
`pip install -e .`

4) Test it.

`sh toy2/data/run_gated_grn.sh`

If this steps finishes then you're good to go


## 
