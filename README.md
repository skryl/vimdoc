# VimDoc

Make your .vimrc self documenting!

<img src="https://www.dropbox.com/s/fbvqgptgat8ir6c/vimdoc.png?dl=1" style="width: 400px;"/>

# What's it do?

Parses comments and key bindings from your .vimrc

```vim
...

" NAVIGATION

... messy vim configs live here ...

"" simplify window movement

... and here ...

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

...
```

And turns them into a clean and colorful (if you run it from the shell) document.

```
################################################################################
#                                 NAVIGATION                                   #
################################################################################
#                           simplify window movement                           #
#                                                                              #
#            nnoremap <C-h>            =>                <C-w>h                #
#            nnoremap <C-j>            =>                <C-w>j                #
#            nnoremap <C-k>            =>                <C-w>k                #
#            nnoremap <C-l>            =>                <C-w>l                #
################################################################################
```

## Installation

If you don't have a preferred installation method, I recommend installing pathogen.vim, and then simply copy and paste:

```bash
cd ~/.vim/bundle
git clone git://github.com/skryl/vimdoc.git
```

## Usage

### From Vim

Just run the :Vimdoc command!

### From the command line

Copy or symlink the vimdoc.rb script from within the plugin folder and run it from your commandline like so:

```bash
ruby vimdoc.rb
```

## Markup Rules

* A heading - a capital letter following a left aligned double quote
* A comment - two double quotes in a row
* A mapping - any valid vim key mapping should be parsed

