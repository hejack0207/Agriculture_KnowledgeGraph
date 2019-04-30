SHELL:=/usr/bin/zsh

all:

treenode_list.txt:
	dfs_crawler.py

leaf_list.txt: treenode_list.txt
	leaf_list_crawler.py

crawled_leaf_list.txt:
	create_leaflist.py

.PHONY: all
