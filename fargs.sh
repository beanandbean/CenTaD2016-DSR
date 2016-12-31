echo "-f `cat tuning/result-$1.modules | awk '{print "modules/"$0".py"}' | tr "\n" " " | sed "s: $::g; s: : -f :g"`"
