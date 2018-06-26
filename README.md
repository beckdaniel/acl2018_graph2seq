# acl2018_graph2seq
Code for:

"Graph-to-Sequence Learning using Gated Graph Neural Networks"
Daniel Beck, Gholamreza Haffari, Trevor Cohn
ACL 2018

## Requirements

It is highly recommended to use a Python virtual environment for this. The code is based on the Sockeye toolkit for NMT and uses an earlier version of MXNet. We plan to merge the latest Sockeye master branch soon, which uses the last MXNet version but for now we keep those steps for the sake of reproduction.

0) (optional) Install virtualenv and create a new virtual environment. Follow the steps in here:

https://virtualenv.pypa.io/en/stable/

1) Install MXNet. This was tested on MXNet 1.1.0. If you're only using CPU:

`pip install mxnet`

If you want GPUs:

`pip install mxnet-cu80`

or other more recent packages depending on your cuda version. Check the MXNet page for more details.

2) Clone my Sockeye fork:

`git clone https://github.com/beckdaniel/sockeye.git`

3) Change to branch `acl2018` and install Sockeye. Any extra requirements will be installed automatically.

`cd sockeye`
`git checkout acl2018`
`pip install -e .`

4) Now let's test it, first train a toy model:

`cd toy`
`./run_ggnn_toy.sh`

And now try to decode it:

`./decode_ggnn_toy.sh`

If both these steps run without errors and you get some random German output, then you're good to go. =)

## Ok, but what just happened?

Before reading this, it is better to go through the Sockeye tutorial first. I am going to assume you're familiar with the Sockeye API from now on.

Check `toy/run_ggnn_toy.sh`. It contains a bunch of new options which are restricted to this Sockeye fork. Let's start with the new data options.

### Data

The key thing to remember is that inputs are now graphs. We represent graphs using two files, where each line is a graph. The first file contains a list of nodes, where each space-separated token is considered a node. This could be a tokenised sentence, for instance, where each word would be represented as a node. The second file contains a list of adjacencies, where each triple (<src>,<tgt>,<label>) is an edge. <src> and <tgt> are node *indices*, in the corresponding node list in the first file. <label> is just the edge label. Finally, there is also a JSON file containing the edge vocabulary, similar to what Sockeye uses as vocabulary files for source and target languages as well.

The nodes file is given in the `--source` option, while `--source-graphs` gives the adjacency lists. For validation data, the corresponding options are `--validation-source` and `--val-source-graphs`. Finally, the vocabulary containing the edge labels is given through teh `--edge-vocab` option.

### Training

The remaining new options are related to the new encoder, a Gated Graph Neural Network. However, for historical reasons, I abbreviated it as `grn` in the API. This will probably change in the future. Here is a list of what all `grn` based options do:

`--use-grn`: this sets the GGNN as the primary encoder

`--skip-rnn`: the default setting is to run an RNN on the node list before sending the hidden states to the GGNN. Setting this flag gets rid of the RNN layer: now it's only an GGNN. You should probably always use this option tbh. I'll probably reverse the default behavior in the future.

`--grn-type {gated,residual}`: you should probably go for `gated` here, as it activates GGNN. In the early days, I tried a simpler version with residual connections instead of gates: that's what the `residual` option does.

`--grn-activation {tanh,relu,sigmoid}`: self-explanatory. ReLU tends to give me better results.

`--grn-num-layers {<INT>}`: self-explanatory. Note that parameters are shared between layers so increasing this will not increase the number of parameters. However, it will increase the computation graph size, demanding more memory and making things a bit slower. For ACL, I used 8 and I think it is a good starting point but this should probably be tuned.

`--grn-num-networks {<INT>}`: this allows you to stack GGNNs on top of each other. "Isn't it the same as more layers?" No, because different *networks* will have different parameters. This is another historical option that I tried in the past but early experiments didn't show improvements. For ACL, I used 1 network only. But it might be worth to explore this a little bit.

`--grn-num-hidden {<INT>}`: hidden state size in the GGNN. This is also the dimensionality of the output.

`--grn-dropout {<FLOAT 0-1>}`: dropout between GGNN layers. Didn't work well for me though.

`--grn-norm`: this flag enables normalisation when updating each node hidden state. Usually gives me better results.

`--grn-positional`: enables positional embeddings. Notice this is for DAGs only (check the paper).

`--grn-pos-embed`: dimensionality of positional emebddings.

### Decoding

Here is where things start to get ugly...

There are no extra options in decoding, check `toy/decode_ggnn_toy.sh`. But here's the catch, the input graphs format for decoding differ from training. Instead of having two files, nodes and edges, we have a single file containing both. Each line contains a node list (as in training) and an adjacency list (as in training) separated by a TAB. This can easily be done using the `paste` shell command.

The reason for this is again historical and also lazyness in finding a proper way to deal with the decoding API. In the future, this will be made consistent, probably using the single file approach which I think it is simpler.

### Anything else?

Yes, a few more ugly caveats:

- Notice that in both training and decoding we explicitly pass the edge label vocabulary. This is *required*, unlike the usual vocabulary files in Sockeye, which are optional. Why? Because I was too lazy to write code to infer the edge vocabulary from the input data...
- Here are a few more fun caveats for the edge vocabulary:

-- Notice in the example we have an edge label called 's', which stands for self-loops. Notice also that its index is 3. Here's the fun bit: for decoding the self-loop index is *hard-coded*, which means it should *always be 3*. I don't think I have to mention there are plans to fix this...

-- If you're using positional embeddings we will assume that 1) your graphs are DAGs and 2) you have a default edge label. For 2), again, due to hard-coding, the default edge is assumed to have label 'd'. Yes, it will be fixed.

Follow the rules above and you can train your own graph-to-sequence model as well. :)


## AMR generation

### 1) Preprocessing

First step in replicating the AMR generation experiments is to preprocess the data. A few important steps here:

- Get the AMR Sembank (LDC2017T10). We can't distribute it because it's paid. Put the folder called `abstract_meaning_representation_amr_2.0` inside the `data` folder.
- Get the AMR tools from here: https://github.com/nschneid/amr-hackathon
Put the files `amr.py` and `amr.peg` inside `data/src` (TODO: there must a better way to distribute this...)
- Change the repository folder inside `src/regen_amr.sh`

Given these steps, running `src/regen_amr.sh` should be enough to get all you need.

### 2) Training models

TODO

### 3) Decoding, postprocessing and evaluation

TODO


## Syntax-based NMT

We used the data from Bastings et al. (EMNLP 2017), obtained directly from the authors. However, we will put some pointers here in case you want to use your own syntax-based NMT system.

TODO
