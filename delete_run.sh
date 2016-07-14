#!/bin/sh

for file in $*; do

	if [ ! -e $file ]
	then
		echo "File $file not found!"
		continue
	fi  

	uid=`grep "Generated UID" $file | sed -e 's/[^<]*<\([0-9]*\)>./\1/'`

        if [ -z $uid ] 
	then
		echo -n "$file: UID empty! "
                read -p "Delete $file? " -n 1 -r; echo
                if [[ $REPLY =~ ^[Yy]$ ]]
		then
			rm $file; rm `echo $file | sed 's/\.o/.e/'`
 		fi
	else	
		read -p "$file: Really delete UID $uid? " -n 1 -r
		echo    # (optional) move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
        		find output -name "*_t????????-$uid*" -exec rm {} + && \
        			rm $file; \
        			rm `echo $file | sed -e 's/\.o/.e/'`
		fi
	fi

done
