return {
  'mileszs/ack.vim', -- :Ack to find word appearances on project
  init = function()
    vim.g.ackprg = 'ag -S --nocolor --nogroup --column --ignore dist --ignore public/vite-test --ignore public/vite-dev --ignore public/packs-test --ignore public/assets --ignore public/packs --ignore tmp --ignore "./_build" --ignore coverage --ignore node_modules --ignore webclient/node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*" --ignore="*.png" --ignore="*.jpg" --ignore="*.svg" --ignore="*.gz"'
  end,
}
