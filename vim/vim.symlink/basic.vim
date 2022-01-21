"" https://github.com/carlhuda/janus/blob/master/janus/vim/core/before/plugin/settings.vim
""
"" Basic Setup
""

if has('vim_starting') && !has('nvim') && &compatible
  set nocompatible               " Be iMproved
endif
set number            " Show line numbers
set ruler             " Show line and column number
syntax enable         " Turn on syntax highlighting allowing local overrides
set autoread          " Read file changes from disk automatically
au CursorHold * checktime 
" Neovim disallow changing 'enconding' option after initialization
" see https://github.com/neovim/neovim/pull/2929 for more details
if !has('nvim')
  set encoding=utf-8  " Set default encoding to UTF-8
endif

set clipboard=unnamed
set mouse=a


"" Theme

syntax enable
set background=dark
colorscheme solarized
set guifont=Monaco:h14
set cursorline


"" Automatically save the session when leaving Vim
" autocmd! VimLeave * mksession
" Automatically load the session when entering vim
" if filereadable("./Session.vim")
  " autocmd! VimEnter * source ./Session.vim
" endif
" autocmd! SessionLoadPost * source ~/.vimrc


" Set the terminal's title
set title

" Show 3 lines of context around the cursor.
set scrolloff=3

" does nothing more than copy the indentation from the previous line, when starting a new line. Does not interfere with other indentation settings
set autoindent

" automatically inserts one extra level of indentation in some cases. Might interfere with file type based indentation
set smartindent

" Display the mode you're in.
set showmode

" In right bottom corner (before ruler) little useful bits about actual state of keyboard input in normal are displayed.
set showcmd

" you can have unwritten changes to a file and open a new file, without being forced to write or undo your changes first.
" set hidden

" lets you see what the options are when pressing tab
set wildmenu

" complete only up to the point of ambiguity
set wildmode=list:longest

" No beeping.
set visualbell

" Improves smoothness of redrawing
set ttyfast

" Show the line and column number of the cursor position, separated by a comma.
set ruler

" Show the status line all the time
set laststatus=2


""
"" Whitespace
""

set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

if exists("g:enable_mvim_shift_arrow")
  let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
endif

" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the left of the screen

""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

""
"" Wild settings
""

" TODO: Investigate the precise meaning of these settings
" set wildmode=list:longest,list:full

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore librarian-chef, vagrant, test-kitchen and Berkshelf cache
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*

" Ignore rails temporary asset caches
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

""
"" Backup and swap files
""

set backupdir^=~/.vim/_backup//    " where to put backup files.
set directory^=~/.vim/_temp//      " where to put swap files.

"" https://github.com/carlhuda/janus/blob/master/janus/vim/core/before/plugin/statusline.vim
"" if has("statusline") && !&cp
  " set laststatus=2  " always show the status bar

  " Start the status line
  " set statusline=%f\ %m\ %r
  " set statusline+=Line:%l/%L[%p%%]
  " set statusline+=Col:%v
  " set statusline+=Buf:#%n
  " set statusline+=[%b][0x%B]
"" endif

set laststatus=2 " always show the status bar
set statusline=%F%m%r%h%w[%L]%y[%p%%][%04v][%{fugitive#statusline()}]


"" https://github.com/carlhuda/janus/blob/master/janus/vim/core/before/plugin/filetypes.vim
""
"" File types
""

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make setlocal noexpandtab

  " Make sure all mardown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown
  if !exists("g:disable_markdown_autostyle")
    au FileType markdown setlocal wrap linebreak textwidth=72 nolist
  endif

  " make Python follow PEP8 for whitespace ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python setlocal tabstop=4 shiftwidth=4

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif
