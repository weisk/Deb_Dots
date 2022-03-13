#!/bin/sh
set -e

cd $HOME/Desktop/vimwiki/Notas/
nota="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" --preview-window=:80%:wrap)"

#noteFilename="$HOME/Desktop/vi/note-$(date +%Y-%m-%d).md"

if [ -n $nota ]; then
  echo "# Nota del $(date +%Y-%m-%d)" > $nota
fi

nvim -c "norm Go" \
  -c "norm Go## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" $nota
