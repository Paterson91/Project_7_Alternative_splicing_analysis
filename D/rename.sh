find . -name "*siP5*.gz" -exec sh -c '
	for file do
		echo $file
		end=${file##*-}
		echo $end
		newname=Wit_$end
		echo $newname
		mv $file $newname
	done' sh {} +
