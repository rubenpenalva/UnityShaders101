find . -name "*.shader" | while read line; do expand -t 4 $line > $line.new; mv $line.new $line; done
find . -name "*.cginc" | while read line; do expand -t 4 $line > $line.new; mv $line.new $line; done
