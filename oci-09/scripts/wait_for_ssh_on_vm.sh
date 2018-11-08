#!/bin/bash
max_iter=12
i=0; while [ $i -lt $max_iter ]; do
  nc -zw 1 $vm_ip 22;
  if [ "$?" -eq "0" ]; then echo "IB: connected to VM"; break; fi;
  if [ $i -eq $max_iter ]; then echo "IB: Failed to connect to VM"; fi;
  sleep 5; i=$[$i+1]; echo "... waiting";
done
