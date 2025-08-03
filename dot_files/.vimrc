" BEGIN Optional stuff

" PLUGINS START
" use pathogen - makes it easy to install plugins
" execute pathogen#infect()


" for the 'a.vim' plugin:
" use :AS and :AV for swtiching and splitting

" for the vim-cpp-enhanced-highlight plugin in after/syntax/cpp.vim
" highlight class scope
" let g:cpp_class_scope_highlight = 1
" " highlight member variables
" let g:cpp_member_variable_highlight = 1
" " highlight class names in declarations
" let g:cpp_class_decl_highlight = 1
" " highlight template functions - not perfect
" let g:cpp_experimental_simple_template_highlight = 1
" " faster, some missed things - not perfect
" " let g:cpp_experimental_template_highlight = 1
" " library concepts - highlights concept an requires keywords
" let g:cpp_concepts_highlight = 1
" " sometimes vim flags curlies as errors e.g. vector<int> v({1,2,3});
" " workaround
" let no_curly_error=1


" omnicppcomplete
"
" set tags
" set tags+=~/.vim/tags/cpp
" set tags+=~/.vim/tags/usr_include
" set tags+=~/.vim/tags/boost
" TODO: boost tag is very large (> 1gb). Takes a while for vim to load
" suggestions.

" enable namespace search in current file AND (the = 2 option) in included files
" let OmniCpp_NamespaceSearch = 2
" only show options for class autocompletion with appropriate visibility
" let OmniCpp_DisplayMode = 0
" show scope in second column of autocomplete popup (default). Set to 1 for
" last column - slightly harder to read, just moves stuff around 
" let OmniCpp_ShowScopeInAbbr = 0
" show prototype in abbreviation part of popup
" let OmniCpp_ShowPrototypeInAbbr = 1
" " show access level (1 = on default)
" let OmniCpp_ShowAccess = 1
" " the default namespace list to search in 
" let OmniCpp_DefaultNamespaces = ['std', '_GLIBCXX_STD']
" " autocomplete after a dot - obj (1 = on default)
" let OmniCpp_MayCompleteDot = 0
" " autocomplete after a arrow - reference (1 = on default)
" " let OmniCpp_MayCompleteArrow = 1
" " autocomplete after a :: - namespace scope (0 = off default)
" let OmniCpp_MayCompleteScope = 0
" " auto open/close popup menu
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set completeopt=menuone,menu,longest,preview


" syntastic options
" use :SyntasticInfo for info on whether it's on, automatic checking, etc.
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" 
" py linter
" let g:syntastic_python_checkers = ['pylint']
" let g:syntastic_python_pylint_post_args = '--msg-template="{path}:{line}:{column}:{C}: [{symbol} {msg_id}] {msg}"'
" 
" " shell 'linter' - fantastic. gives plenty of great warnings and
" " recommendations on how to fix 
" let g:syntastic_shell_checkers = ['shellcheck']

" c++ checker
" use g++ compiler
" let g:syntastic_c_checkers=['make', 'splint']
" let g:syntastic_cpp_checkers=['cppcheck', 'make']
" let g:syntastic_cpp_compiler = 'g++'
" " compiler options -stdlib=libc++ 
" let g:syntastic_cpp_compiler_options = ' -std=c++17 -Wall -Wconversion -Wextra -pedantic -pthread -lboost_log -lboost_chrono -lboost_atomic -lboost_thread -lboost_date_time -lboost_filesystem -lboost_system -lboost_regex' 
" " check header files (.h, .hh, .hpp)
" let g:syntastic_cpp_check_header = 1
" " limit syntastic window size to 4 lines
" let g:syntastic_loc_list_height = 4
" 
" 
" " nerd-commenter
" add space after comment delimiter by default
" let g:NERDSpaceDelims = 1
" compact syntax for prettified multi-line comments
" let g:NERDCompactSextComs = 1
" allows commenting and inverting empty lines
" let g:NERDCommentEmptyLines = 1

" vim-indent-guides
" automatically do the indentation marking on startup
" let g:indent_guides_enable_on_vim_startup = 1
" required to choose a colorscheme - otherwise get weird error about Normal
" highlight not found
" colorscheme default
" different colors for indents
" don't use auto_colors
" let g:indent_guides_auto_colors = 0
" use these colors
" IndentGuidesOdd is for indentations at levels 1,3,5,...
" ctermbg seems to change difference of color based on background (guibg)
" higher it gets, brighter it gets?
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=darkgrey ctermbg=0
" for levels 2,4,6...
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=0
" change indent guide sizes
" start at the left flush line rather than just first and other tabs
" let g:indent_guides_start_level = 1
" only highlight one character length for tabs
" let g:indent_guides_guide_size = 1
" not sure what this does...
" let g:indent_guides_color_change_percent = 100

" PLUGINS END


" TODO: mapping for tabbing and untabbing lines when in visual line mode

" other built-in shortcuts:
" `` goes to last cursor line and column
" '' goes to beginning of last line
" '. goes to last changed line
" gg to top of file
" G to bottom of file
" :<num>winc> move <num> of columns/rows to the right. Use < for left. Down?
" Up?
" D deletes rest of contents in line from cursor. So, <end>D or 0D will delete
" entire line text, but keep the new line
" L moves to bottom line on screen (not of file)
" M moves to middle line on screen (not of file)
" H moves to top line on screen (not of file)
" % moves to matching bracket {} [] or ()
" <num>k moves cursor <num> lines up
" <num>j moves cursor <num> lines down
" gu makes whole line lowercase 
" gU makes whole line uppercase
" g~ swaps case of whole line 
"
" MARKS:
"   mx sets mark x at current cursor position
"   'x go to beginning of line of mark x
"   `x go to cursor position of mark x
"

" timeout (unit = millis) on mappings after 2 seconds, on key codes after 1 second
set timeout timeoutlen=2000 ttimeoutlen=1000

" default comment character
let g:COMMENT_CHAR = '#'

" set default comment character(s) for certain file extensions
autocmd BufReadPost,BufNewFile *.py,*.sh,*.bash,*.pl let g:COMMENT_CHAR = '#'
autocmd BufReadPost,BufNewFile *.c,*.h,*.cpp,*.hpp,*.hxx let g:COMMENT_CHAR = '//'
autocmd BufReadPost,BufNewFile *.vimrc,*.vim let g:COMMENT_CHAR = '"'
autocmd BufReadPost,BufNewFile *.sql,*.lua let g:COMMENT_CHAR = '--'
function! CommentLine()
  execute ':s/^/' . g:COMMENT_CHAR . ' /'
endfunction

function! UncommentLine()
  execute ':s/^' . g:COMMENT_CHAR . '[ ]\=/'
endfunction

" comment out current line
nnoremap <silent> <leader>cc :call CommentLine()<CR>
" uncomment out current line, removing one space character if it's present
nnoremap <silent> <leader>cu :call UncommentLine()<CR>
nnoremap <F6> <cr>COMMENT_CHAR<CR>


" press <F2> to display current datetime
nnoremap <F2> :echo 'Current time is ' . strftime('%c')<CR>

" nnoremap <F5> :call Preserve("%!astyle -s2")<CR>
" maps CTRL-F12 to generate CTAG of current directory (useful for CPP project
" autocompletion for omnicppcomplete)
" map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" the comment nerd plugin takes <num>\cc and comments that many below lines.
" This is a shortcut to comment the current line
map cc 1<leader>cc<CR>
map cu 1<leader>cu<CR>

"<Left>
nnoremap <F3> ^ 

" Puts in the current git status
" if count(g:pathogen_disabled, 'Fugitive') < 1   
" set statusline+=%{fugitive#statusline()}
" endif
" 
" " Puts in syntastic warnings
" if count(g:pathogen_disabled, 'Syntastic') < 1  
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" endif

" Only do this part when compiled with support for autocommands
" if has("autocmd")
"   augroup redhat
"     autocmd!
"     " In text files, always limit the width of text to 78 characters
"     " autocmd BufRead *.txt set tw=78
"     " When editing a file, always jump to the last cursor position
"     autocmd BufReadPost *
"           \ if line("'\"") > 0 && line ("'\"") <= line("$") |
"           \   exe "normal! g'\"" |
"           \ endif
"     " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
"     autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
"     " start with spec file template
"     autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
"   augroup END
" endif

" statusline customization
" function! InsertStatuslineColor(mode)
"   if a:mode == 'i'
"     hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
"   elseif a:mode == 'r'
"     hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
"   else
"     hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
"   endif
" endfunction

" au InsertEnter * call InsertStatuslineColor(v:insertmode)
" au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
" hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
 
" END Optional stuff


" BEGIN important stuff

" smart indenting based on file type
filetype indent plugin on

" set nocp
filetype plugin on
" return back to original cursor position after running a command.
" must call Preserve(<your command here>) for this to work
function! Preserve(command)
  " get window view - cursor position, line number, window height/width,
  " etc.
  let w = winsaveview()
  " execute given command
  execute a:command
  " restore that view so it's like the cursor never moved during the
  " command
  call winrestview(w)
endfunction

function! HighlightOff()
  :noh
endfunction

set hidden
" better auto-complete
set wildmenu
" show commands as you're typing in bottom right
set showcmd
" show filename as title in specific format
set title

" highlight search results
set hlsearch
" search incrementally (search while typing)
set incsearch

" set smartcase

" smart indenting
set autoindent
" set default tab width
set shiftwidth=2
set softtabstop=2
set tabstop=2
" spaces are superior
set expandtab

" smart backspace over autoindent, EOL, insert start
set backspace=indent,eol,start

function! SetTabLengthRange() range
  let &l:shiftwidth = v:count
  let &l:softtabstop = v:count
  let &l:tabstop = v:count
endfunction

function! SetTabLength(len)
  let &l:shiftwidth = a:len
  let &l:softtabstop = a:len
  let &l:tabstop = a:len
endfunction

" a little easier with new line typing
" starts your typing closer to where you'd expect
" set nostartofline

" keeps track of line number/column number
" set ruler

set laststatus=2

" syntax highlighting
syntax on

" absolute line numbers
" set number
" relative line numbers
" set relativenumber
" hybrid - preferred
set number relativenumber

" asks for confirmation instead of failing
" e.g. if forgetting to write
set confirm

" if in an xterm, allows some mouse usage
" set mouse=a
" don't allow mouse usage
set mouse=

" set file indentation based on certain file extensions
autocmd BufReadPost,BufNewFile *.py,*.java,*.xml :call SetTabLength(4)
autocmd BufReadPost,BufNewFile *.vimrc,*.vim,*.lua,*.sql,*.sh,*.bash,*.pl,*.html,*.js,*.c,*.h,*.cpp,*.hpp,*.hxx,*.rb :call SetTabLength(2)

" Set default line length
autocmd BufRead *.py,*.txt,*.c,*.h,*.hpp,*.cpp,*.hxx,*.md,*.sh,*.bash,*.adoc set tw=100

" press <F4> to fix indentation in entire file
" nnoremap <F4> gg=G``      " also works
nnoremap <F4> :call Preserve("normal gg=G")<CR>
" set ignorecase for when searching
nnoremap <leader>ii :set ignorecase<CR>
nnoremap <leader>io :set noignorecase<CR>

" enable/disable paste from clipboard
nnoremap <leader>pp :set paste<CR>
nnoremap <leader>po :set nopaste<CR>
" every time hit <enter>, clear most recent search
" <silent> means don't show command in bottom left
nnoremap <silent> <CR> :noh<CR><CR>
nnoremap <leader>tl :call SetTabLengthRange()<CR>
" copy whole file into default buffer
nnoremap <leader>cpa :call Preserve("normal ggVGy")<CR>

" Formats the statusline
set statusline=%f                           " file name
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y      "filetype
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number
set statusline+=\ [%b][0x%B]              " ASCII and byte code under cursor

" END important stuff
