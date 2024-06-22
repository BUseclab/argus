#!/bin/bash
G="\033[32m"
R="\033[0;31m"
NC="\033[0m"

if [ -n "$1" ]; then
	case "$1" in
	"all")
		echo -e "${G}[+] Building the docker${NC}"
		docker build -t extended-psalm:1.0 .
		
		echo -e "${G}[+]Running extended-psalm and getting a shell${NC}"
		docker run --rm --name phase-3 -it extended-psalm:1.0 bash
		;;	
	"build")
		echo -e "${G}[+] Building the docker${NC}"
		docker build -t extended-psalm:1.0 .
	;;
	"shell")	
		echo -e "${G}[+]Running extended-psalm and getting a shell${NC}"
		docker run --rm --name phase-3 -it extended-psalm:1.0 bash
	esac
else
	echo -e "${R}Provide 'build', 'run', or 'all' as an argument${NC}"
fi
