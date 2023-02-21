" author: bngtrue
" здесь я собрал самые необходимые мне настройки и плагины для работы с c++
" буду рад если он поможет новичкам в vim(я и сам новичёк), хотябы выполнить начальную
" настройку своего конфигурационного файла vimrc

"-------------------------------------------------------------------------------------------------------------

"                                   общие тривиальные настройки

set nocompatible " отключить совместимость с Vi
set number " номера строк
set numberwidth=5 " ширина для номеров строк (в символах)
set syntax " включить подсветку синтаксиса
color desert " включить тему 'пустыня'
let mapleader = " "

"-------------------------------------------------------------------------------------------------------------

"                                   настройка командной строки (cmd)

set noshowmode " убрать отображение режима Vim (допустим командный режим)
set showcmd " отображать команды вводимые команды в строке состояния (cmd)
set cmdheight=2 " высота командной строки
set updatetime=300 " больше частота обновлений диагностических сообщений
set laststatus=2 " строка состояния будет отображаться всегда, даже если открыто одно окно (buff)

"-------------------------------------------------------------------------------------------------------------

"                                   настройка табов и отступов (<Tab>, <Slash>)

set tabstop=2 " установливает количество пробелов для <Tab> (в файле)
set softtabstop=2 " установливает количество пробелов для <Tab> (в режиме вставки)
set shiftwidth=2 " количество пробелов для оступа для команд '>', '<' для смещения текста вправо и влево
set expandtab " испольует  пробелы для <Tab> вместо символа табуляции, например вместо '\t'
set smarttab " испольует 'shiftwidth' при вставке <Tab>
set smartindent " автоотступ для новых строк по предыдущей, но ещё и умный в отличии от 'autoindent'
set backspace=indent,eol,start " indent,eol,start

"-------------------------------------------------------------------------------------------------------------

"                                   файлы

set title " отображает имя файла в заголовке
set nobackup " не делать резервные копии измененного файла
set noswapfile " не использовать для буфера файла подкачки .swp
set autowrite " автоматически записывает файл при изменении
set autoread " автоматически считывает файл при изменени
set shortmess=atI " управление строкой состояния, допустим a - не выводить sms об авто-командах
set encoding=utf-8 " установить кодировку UTF8 для корректного отображения кирилицы
set ffs=unix,dos,mac " установить стандарт использования символов переноса строки в файлах

"                                   поиск по файлу

set ignorecase " команды поиска нечувствительны к регистру слов(символов)
set incsearch " при вводе слова постепенно выделяет символы
set hlsearch " включить подсветку символов
set smartcase " умный режим регистра при поиске текста

"-------------------------------------------------------------------------------------------------------------

"                                   наcтройка переносов строк

set wrap " перенос длинных строк
if &filetype == 'cpp' || &filetype == 'h'
  set textwidth=80 " максимальная длина для переноса строк в соответствии с Google Style
else
  set textwidth=110
endif

"-------------------------------------------------------------------------------------------------------------

"                                   подсветка ограничения "wrap"

if &filetype == 'cpp' || &filetype == 'h'
  set colorcolumn=81
else
  set colorcolumn=111
endif
highlight ColorColumn ctermbg=red

"-------------------------------------------------------------------------------------------------------------

"                                   завершающие пробелы

" мы хотим видеть пробелы, т.к некоторые соглашения ограничивают оставление завершающих пробелов
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

"                                   map для этих пробелов

" map для того чтобы все остающиеся завершающие пробелы убрать сочетанием клавич <leader>rs
nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

"-------------------------------------------------------------------------------------------------------------

"                                   мои сочетания клавиш

" более удобное перемещение между открытыми вкладками редактора
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"-------------------------------------------------------------------------------------------------------------

"                                   тут настройки для работы с c++

" переключение между header/source c F4
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" Определяем компилятор для языка C и C++
" let $CC = 'clang'
" let $CXX = 'clang++'

" Включаем автодополнение для C и C++
" set omnifunc=ccomplete#Complete

"                                   cmake

" Параметры компиляции и отладки C++
" set makeprg=cd\ build\ &&\ cmake\ --build\ .
" set errorformat=%f:%l:\ %m

function! GetProjectName()
    let cmakefile = findfile("CMakeLists.txt", ".;")
    let projectname = substitute(system("grep -oP '^project\\s*\\(\\K[^)]*' " . cmakefile), '\n', '', 'g')
    return projectname
endfunction

function! BuildAndRun()
    let build_dir = 'build'
    let binary_name = substitute(systemlist('cmake --build ' . build_dir . ' --target all -- -j $(nproc)'), '\n', '', '')
    execute 'cd ' . build_dir
    execute '!cmake .. && make'
    execute '!./' . GetProjectName()
endfunction

" <F5> - сборка и запуск бинарника
nnoremap <F5> :call BuildAndRun()<CR>

"-------------------------------------------------------------------------------------------------------------

"                                   плагины

call plug#begin('~/.vim/plugged')
Plug 'Valloric/YouCompleteMe'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

"                                   nerdtree

nnoremap <leader><C-f> :NERDTreeFind<CR>

"-------------------------------------------------------------------------------------------------------------
