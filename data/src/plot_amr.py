from graphviz import Digraph
import argparse


def gen_dot(nodes, triples):
    dot = Digraph()
    node_ids = nodes.split()
    new_nodes = []
    for i, node in enumerate(node_ids):
        if node.startswith(':'):
            new_node = node[1:].upper() + '_' + str(i)
        else:
            new_node = node + '_' + str(i)
        dot.node(new_node)
        new_nodes.append(new_node)
    for triple in triples.split():
        src, tgt, label = triple[1:-1].split(',')
        #print((src, tgt, label))
        #print((node_ids[int(src)], node_ids[int(tgt)]))
        #dot.edge(new_nodes[int(src)] + '_' + src,
        #         new_nodes[int(tgt)] + '_' + tgt)
        #if label == 'default':
        dot.edge(new_nodes[int(src)],
                 new_nodes[int(tgt)],
                 label=label)
    dot.view()
    #import ipdb; ipdb.set_trace()






parser = argparse.ArgumentParser()
parser.add_argument('input_nodes', type=str)
parser.add_argument('input_triples', type=str)
#parser.add_argumet('', type=str)
parser.add_argument('--index', type=int, default=1)
args = parser.parse_args()


with open(args.input_nodes) as f:
    nodes_lines = f.readlines()
with open(args.input_triples) as f:
    triples_lines = f.readlines()

i = 1
for nodes, triples in zip(nodes_lines, triples_lines):
    if i == args.index:
        dot = gen_dot(nodes, triples)
    i += 1
