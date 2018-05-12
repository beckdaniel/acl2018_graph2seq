python -m sockeye.translate -m toy_model \
       --edge-vocab edge_vocab.json \
       --use-cpu \
       --max-input-len 50 < val.en.tokdeps
