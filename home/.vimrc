syntax enable           " enable syntax processing
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set number              " show line numbers
set ruler
set mouse=a
set showmode
set showcmd             " show command in bottom bar
filetype indent on      " load filetype-specific indent files
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches, cancel with :nohlsearch

set tags=./tags,tags;$HOME
let c_space_errors=1
