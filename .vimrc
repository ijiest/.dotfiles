""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neovim python provider
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if $SHELL =~ 'fish'
	set shell=bash
endif

" check shell
" if $SHELL =~ 'fish'
" 	let g:python3_host_prog = system('echo -n (pyenv root)/versions/(pyenv global)/bin/python3')
" else
	let g:python3_host_prog = system('echo -n "$(pyenv root)/versions/$(pyenv global)/bin/python3"')
" endif

" let g:python_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/$(pyenv global)/bin/python") || echo -n $(which python2)')

if !&compatible
	set nocompatible
endif

"reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => dein.vim settings 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir)) 
endif

let &runtimepath = s:dein_repo_dir .",". &runtimepath

"read plugin
let s:toml_file = expand('$HOME/.dotfiles/vim/plugins/toml').'/dein.toml'
let s:toml_lazy_file = expand('$HOME/.dotfiles/vim/plugins/toml').'/dein_lazy.toml'
let s:deoplete_toml_file = expand('$HOME/.dotfiles/vim/plugins/toml').'/deoplete.toml'
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)
	call dein#load_toml(s:toml_file,      {'lazy':0})
	call dein#load_toml(s:toml_lazy_file, {'lazy':1})
	call dein#load_toml(s:deoplete_toml_file, {'lazy':0})
	call dein#end()
	call dein#save_state()
endif

filetype plugin indent on
colorscheme gotham
syntax enable

"auto install if not
if has('vim_starting') && dein#check_install()
	call dein#install()
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim basic settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"highlight cursorline ohter than insert mode
autocmd WinEnter     * set cursorline
autocmd WinLeave     * set nocursorline
autocmd InsertEnter  * set nocursorline
autocmd InsertLeave  * set cursorline
highlight CursorLine term=reverse cterm=none ctermbg=235

"quickfix
autocmd FileType qf nnoremap <silent><buffer>q :quit<CR>
"<S-k> jump to vim help
augroup setKhelp
	autocmd!
	autocmd FileType vim setlocal keywordprg=:help
augroup END

set showcmd
set number
set relativenumber
set ruler
set noswapfile
set title
set hlsearch
set incsearch
set wildmenu 
set wildmode=list:full
set nobackup
set hidden
"setting matching pair like <>,()
set showmatch
set matchtime=1
"set smarttab
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
"display tab and eol
set list
"symbol of tab,trail,eol
set listchars=tab:»-,trail:-,nbsp:%,eol:$
set whichwrap=b,s,h,l,<,>,[,],~
set wrapscan
set ignorecase
set smartcase
set encoding=utf-8
set nowrap
set history=2000
set helplang=en
set scrolloff=5
if !has('nvim')
set viminfo+=n$HOME/.local/share/viminfo
endif
set display=lastline
set foldmethod=marker
set autoread
set undofile
set undodir=$HOME/.local/share/nvim/undo
set backspace=indent,eol,start
" C-a and C-x motion ignore octal
set nrformats=
set timeout timeoutlen=1000 ttimeoutlen=75
"disable mouse
set mouse=
set splitright
set splitbelow
set noshowmode
set modifiable
set write
set laststatus=2
"set completion's height
set pumheight=10
"set clipboard
if has('unnamedplus')
	set clipboard+=unnamedplus,unnamed
else
	set clipboard+=unnamed
endif

set infercase
"open buffer instead of open new
set switchbuf=useopen
"no flush and no beep
set vb t_vb=
"add < > pair
set matchpairs+=<:>
"make scroll faster and stable
set ttyfast
set lazyredraw
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Prefix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap [Plug] <Nop>
nmap  <Space> [Plug]
xnoremap [Plug] <Nop>
xmap  <Space> [Plug]
nnoremap [Meta] <Nop>
nmap  , [Meta]
xnoremap [Meta] <Nop>
xmap  , [Meta]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Zoom/Restore window.
function! ZoomToggle() abort
	if exists('t:zoomed') && t:zoomed
		execute t:zoom_winrestcmd
		let t:zoomed = 0
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = 1
	endif
endfunction
nnoremap <silent> [Meta]z :<C-u>call ZoomToggle()<CR>
"source ~/.vimrc
nnoremap <silent> [Meta]v :<C-u>source ~/.vimrc<CR>
" toggle spell
nnoremap <silent> [Meta]s :<C-u>setl spell! spell?<CR>
" toggle list
nnoremap <silent> [Meta]a :<C-u>setl smartindent! smartindent?<CR>
nnoremap <silent> [Meta]l :<C-u>setl list! list?<CR>
nnoremap <silent> [Meta]t :<C-u>setl expandtab! expandtab?<CR>
nnoremap <silent> [Meta]w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> [Meta]p :<C-u>setl paste! paste?<CR>
nnoremap <silent> [Meta]b :<C-u>setl scrollbind! scrollbind?<CR>
nnoremap <silent> [Meta]m :<C-u>Man 
function! s:toggle_syntax() abort
	if exists('g:syntax_on')
		syntax off
		redraw
		echo 'syntax off'
	else
		syntax on
		redraw
		echo 'syntax on'
	endif
endfunction
nnoremap <silent> [Meta]y :call <SID>toggle_syntax()<CR>

"move buffer
nnoremap <silent> <C-n> :<C-u>bn<CR>
nnoremap <silent> <C-p> :<C-u>bp<CR>
"move ^ and $
noremap <S-h> ^
noremap <S-l> $
"move window
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-f> <C-o>w
inoremap <C-b> <C-o>b
inoremap <C-d> <C-o>x
inoremap <silent> jj <ESC>
inoremap <silent> kk <ESC>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"search inside selected range
vnoremap z/ <ESC>/\%V
vnoremap z? <ESC>?\%V

"reselect after < or >
xnoremap < <gv
xnoremap > >gv

"visual to the end of the line
vnoremap v $h

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" save as sudo with w!!
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

function! s:search(pat)
    let g:search_yank_cache = []
    execute '%s/' . a:pat . '/\=add(g:cache, submatch(0))/n'
    call setreg(v:register,join(g:search_yank_cache, "\n"))
endfunction
command! -nargs=* SearchYank call s:search(<q-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Terminal mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
	tnoremap <silent> <ESC> <C-\><C-n>
endif
