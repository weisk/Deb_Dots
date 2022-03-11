" ░█░█░▀█▀░█▄█
" ░▀▄▀░░█░░█░█
" ░░▀░░▀▀▀░▀░▀


" ------Global configs:

	filetype plugin on
	let g:ShiftTabDefaultCompletionType = "<C-X><C-O>"
	runtime! debian.vim
	set autoread wildmode=longest,list,full
	set complete+=k
	set cursorline cursorcolumn
	set dictionary+=/usr/share/dict/words
	set hlsearch
	set ignorecase
	set incsearch
	set joinspaces
	set laststatus=2
	set list
	set listchars=tab:▸\ ,eol:¬
	set mouse=a
	set nocompatible
	set noshowmode
	set nostartofline
	set number relativenumber
	set omnifunc=syntaxcomplete#Complete
	set showmatch
	set spell spelllang=es,en_us  	
	set spellsuggest=10
	set splitbelow
	set splitright
	set wildmenu
	syntax on


" ------Keybindings:

	"Return to normal mode:
		imap fd <Esc>
		vmap fd <Esc> 

	"Toggle Goyo: 
		nmap <Space> :Goyo <CR>

	"Vim-like movement between splits:	
		nnoremap <C-h> <C-W>h
		nnoremap <C-j> <C-W>j
		nnoremap <C-k> <C-W>k
		nnoremap <C-l> <C-W>l  

	"Resize splits with arrow keys:
		nnoremap <Left>  :vertical resize +2<CR>
		nnoremap <Right> :vertical resize -2<CR>
		nnoremap <Down> :resize -2<CR>
		nnoremap <Up> :resize +2<CR>


	"Primary selection and clipboard copy and paste:
		vnoremap <C-c> "+y
		map <C-p> "+P
		vnoremap <C-c> "*y :let @+=@*<CR>

	"Move lines when in visual mode up or down:
		xnoremap K :move '<-2<CR>gv-gv
		xnoremap J :move '>+1<CR>gv-gv


" ------Plug-ins: 

	call plug#begin(expand('~/.vim/pluged'))
	Plug 'arcticicestudio/nord-vim' 
	Plug 'junegunn/goyo.vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'vimwiki/vimwiki'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'michal-h21/vim-zettel'
	Plug 'jalvesaq/zotcite'
	call plug#end()


" ------Colorschemes:

	colorscheme nord 


" ------Status Line:

	"Status colors:
		au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
		au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
		hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
	
	"Status modes:
		let g:currentmode={
		    \ 'n'  : 'Normal',
		    \ 'no' : 'Normal·Operator Pending',
		    \ 'v'  : 'Visual',
		    \ 'V'  : 'V·Line',
		    \ "\<C-v>" : 'Visual·Block',
		    \ 's'  : 'Select',
		    \ 'S'  : 'S·Line',
		    \ '^S' : 'S·Block',
		    \ 'i'  : 'Insert',
		    \ 'R'  : 'Replace',
		    \ 'Rv' : 'V·Replace',
		    \ 'c'  : 'Command',
		    \ 'cv' : 'Vim Ex',
		    \ 'ce' : 'Ex',
		    \ 'r'  : 'Prompt',
		    \ 'rm' : 'More',
		    \ 'r?' : 'Confirm',
		    \ '!'  : 'Shell',
		    \ 't'  : 'Terminal'
		    \}
	
	"Status modules:
		set statusline=
		set statusline+=\ \ %{toupper(g:currentmode[mode()])}\ 
		set statusline+=%#CursorLineNr#					
		set statusline+=%1*\ %<%F%m%r%h%w\ [%{&spelllang}\]\ 		
		set statusline+=%#PmenuSel#				
		set statusline+=\ %y\ %{&fileencoding?&fileencoding:&encoding}\ 
		set statusline+=%#CursorLineNr#				
		set statusline+=%1*\ ln:\ %02l/%L\ (%p%%)\ [col:%c] 
		set statusline+=%=				
		set statusline+=%0*\ %n\ 		


" ------Goyo functions: 

	function! s:goyo_enter()
	set nocursorline nocursorcolumn
	endfunction
	
	function! s:goyo_leave()
	hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
	set cursorline cursorcolumn
	endfunction

	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave() 


" -----Vimwiki:

	let g:vimwiki_list = [{'path': '~/Desktop/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags':1}]


" -----Zotcite:

	let zotcite_filetypes = ['markdown', 'pandoc', 'rmd', 'vimwiki']
