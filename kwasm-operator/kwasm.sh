#!/usr/bin/env bash
set -euo pipefail

annotate_nodes() {
  echo "Operating System: $(uname -s)"
  echo "Architecture: $(uname -m)"
  echo $(which kubectl)

  if [[ "$1" == "all" ]]; then
    kubectl annotate node --overwrite --all kwasm.sh/kwasm-node=true 
    return
  fi

  IFS=',' read -ra ADDR <<< "$1"
  for node in "${ADDR[@]}"; do
    kubectl annotate node $node --overwrite kwasm.sh/kwasm-node=true
  done
}

remove_annotation_from_nodes(){
  if [[ "$1" == "all" ]]; then
    kubectl annotate node --all kwasm.sh/kwasm-node-
    return
  fi

  IFS=',' read -ra ADDR <<< "$1"
  for node in "${ADDR[@]}"; do
    kubectl annotate node $node kwasm.sh/kwasm-node-
  done
}

# Call the requested function and pass the arguments as-is
"$@"
