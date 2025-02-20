#!/bin/bash

#░█▀▄░█▀█░█▀▀░█░█░░░█▀▀░█░█░█▀█░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
#░█▀▄░█▀█░▀▀█░█▀█░░░█▀▀░█░█░█░█░█░░░░█░░░█░░█░█░█░█░▀▀█
#░▀▀░░▀░▀░▀▀▀░▀░▀░░░▀░░░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀


# ------Make a new directory and cd into it immediately:
	mkcd() {
		mkdir "$1"
		cd "$1"
	}


# ------Create quick notes on random topics:
 	jot() {
 		touch ~/Desktop/Notes/"$1"
		nvim ~/Desktop/Notes/"$1"
 	}


# ------Kill processes in a fuzzy way:
	fkill() {
	  local pid
	  pid="$(
	    ps -ef \
	      | sed 1d \
	      | fzf -e -m --cycle --reverse \
	      | awk '{print $2}'
	  )" || return
	  kill -"${1:-9}" "$pid" &> /dev/null
	}


# ------Browse and open notes quickly:
	fjot() {
		cd ~/Desktop/Notes/
		note="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF \
		--preview="head -$LINES {}" --bind="space:toggle-preview" --preview-window=wrap:hidden)"
			if [ -n "$note" ]; then
			nvim "$note"
			else
				&>/dev/null
			fi
		cd
	}


# ------Use fzf as a script editor:
	fsh() {
		cd $HOME/.local/bin/
		script="$(fdfind -t f -H | fzf --cycle --reverse --color=border:#FFFFFF \
		--preview="head -$LINES {}" --bind="space:toggle-preview" \
		--preview-window=wrap:hidden)"
			if [ -n "$script" ]; then
			nvim "$script"
			else
				&>/dev/null
			fi
		cd
	}


# ------Use fzf as a file opener:
	fo() {
		file="$(fdfind -t f -H | fzf --reverse --preview="head -$LINES {}" \
		--bind="space:toggle-preview" --preview-window=wrap:hidden)"
		if [ -n "$file" ]; then
			mimetype="$(xdg-mime query filetype $file)"
			default="$(xdg-mime query default $mimetype)"
		    		if [[ "$default" == "nvim.desktop" ]]; then
		        		nvim "$file"
		    		else
		        		&>/dev/null xdg-open "$file" & disown; exit
		    		fi
		fi
	}


# ------Use fzf to move between directories:
	fd() {
		cd;cd "$(fdfind -t d -H | fzf --cycle --reverse --color=border:#FFFFFF \
		--preview="tree -L 1 {}" --bind="space:toggle-preview" \
		--preview-window=wrap:hidden)" && clear
	}


# ------Give Apt fuzzy-like package management abilities:
	debcrawler() {
		repos="$(apt-cache pkgnames | fzf --multi --color=border:#FFFFFF  --cycle \
		--reverse --preview "apt-cache show {}" --preview-window=:80%:wrap:hidden \
		--bind=space:toggle-preview)"
		if [ -n "$repos" ]; then
		sudo apt update && sudo apt install "$repos"
		else
			&>/dev/null
		fi

	}


# -----Fuzzy find packages with Apt:
	lookapt() {
		repos="$(apt-cache pkgnames | fzf --multi --color=border:#FFFFFF  --cycle \
		--reverse --preview "apt-cache show {}" --preview-window=:80%:wrap:hidden \
		--bind=space:toggle-preview)"
		if [ -n "$repos" ]; then
		apt search --names-only "$repos"
		else
			&>/dev/null
		fi
	}


# ------Clean system:
	debclean() {
		sudo apt clean
		sudo apt autoclean
		sudo apt autoremove --purge 
		flatpak uninstall --unused
	}


# ------Wayland's color picker:
	waypick() {
		grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-
	}


# ------Update Deb_Dots:
	debgit() {
		git add -u
		git commit -m "$1"
		git push -u
	}


#-------Update Vimwiki:
	vimgit() {
		cd $HOME/Desktop/vimwiki/
		git add .
		git commit -m "$1"
		git push -u
		cd
	}


# ------Update Blender:
	buildblend() {
		cd
		cd $HOME/blender-git/blender
		make update
		make
	}


# ------Count files or directories in directory:
	count() {
		# Usage: count /path/to/dir/*
		# count /path/to/dir/*/
		[ -e "$1" ] \
		&& printf '%s\n' "$#" \
		|| printf '%s\n' 0
	}


# As a side note for the following, as Debian 11 uses an older version of
# pandoc, the flag '-F pandoc-citeproc' is needed for this function to work.
# However, on newer versions of pandoc (pandoc-citeproc has been deprecated 
# by upstream in favor of citeproc in pandoc v2.11.0.4 [2020-10-21]), this
# flag should not be used anymore. Instead, use the '--citeproc' flag.

# -----Convert markdown notes into letter pdfs:

	mdpdf() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" --pdf-engine=xelatex -V 'fontsize:10pt' -V 'indent:yes' \
			--variable monofont="Menlo" -V "geometry:margin=5.08cm" -V 'papersize:letter' \
			-M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py -F pandoc-citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}


# -----Convert markdown notes into half letter pdfs:
	hlpdf() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" --pdf-engine=xelatex -V 'fontsize:10pt' -V 'indent:yes' \
			--variable monofont="Menlo" -V "geometry:paperheight=21.6cm,paperwidth=14cm,margin=2.54cm" \
			-V 'pdfa=true' -V 'pdfaiccprofile=default.cmyk' -M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py -F pandoc-citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}


# -----Convert markdown notes into simple html files:
	mdhtml() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		htmltoread="${doc%%.*}"
		cleanpdfname="${htmltoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" -M lang:es-MX -s -o $HOME/Desktop/vimwiki/Htmls/"$cleanpdfname".html \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py -F pandoc-citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			fi
	}


# ------Sid exclusive functions:

# -----Convert markdown notes into letter pdfs:
	sidmdpdf() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" --pdf-engine=xelatex -V 'fontsize:10pt' -V 'indent:yes' \
			--variable monofont="Menlo" -V "geometry:margin=5.08cm" -V 'papersize:letter' \
			-M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py --citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}


# -----Convert markdown notes into half letter pdfs:
	sidhlpdf() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" --pdf-engine=xelatex -V 'fontsize:10pt' -V 'indent:yes' \
			--variable monofont="Menlo" -V "geometry:paperheight=21.6cm,paperwidth=14cm,margin=2.54cm" \
			-V 'pdfa=true' -V 'pdfaiccprofile=default.cmyk' -M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py --citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}


# -----Convert markdown notes into simple html files:
	sidmdhtml() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		htmltoread="${doc%.*}"
		cleanpdfname="${htmltoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" -M lang:es-MX -s -o $HOME/Desktop/vimwiki/Htmls/"$cleanpdfname".html \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py --citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			fi
	}


# -----Convert markdown notes into letter odts:
	sidmdodt() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" \
			-M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".odt \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py --citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".odt & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}


# -----Convert markdown notes into letter docxs:
	sidmddocx() {
		cd $HOME/Desktop/vimwiki/
		doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
			--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
		pdftoread="${doc%.*}"
		cleanpdfname="${pdftoread##*/}"
			if [ -n "$doc" ]; then
			pandoc "$doc" \
			-M lang:es-MX -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".docx \
			-F $HOME/.vim/pluged/zotcite/python3/zotref.py --citeproc \
			--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ;\
			xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".docx & disown; exit
			else
				cd ; &>/dev/null 
			fi
	}
