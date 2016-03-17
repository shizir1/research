#!/bin/bash +vx
#hardcoded parameters
HADOOP_HOME=/var/work/shizir1/hadoop-1.2.1
SPARK_HOME=/var/work/shizir1/spark-1.6.0-bin-hadoop1
HIBENCH_HOME=/var/work/shizir1/HiBench
timestamp=$(date +%s)

if [ "$#" -ne 3 ]; then
    tput setaf 1;echo "Usage ./runclean [list of machines]  [commands to run on remote machines] [number of hi-bench iterations]";tput sgr0;
    exit;
fi

for ((iter = 1; iter <= $3; iter++));
do
	echo "Running $3 iterations"
	###### ---> stop hadoop/spark
	$HADOOP_HOME/bin/stop-all.sh
	$SPARK_HOME/sbin/stop-all.sh

	####### ---> run
	for machines in `cat $1`
	do
   		ssh $machines 'bash -s' < $2
	done

	sleep 10

	#### ---> start hadoop/spark
	$HADOOP_HOME/bin/start-all.sh
	$SPARK_HOME/sbin/start-all.sh

	sleep 60

	#### ---> start workload
	echo "Starting workload...."
	$HIBENCH_HOME/bin/run-all.sh

	# Run ./generate command
	echo "iteration $iter completed. Generating the report..."
	#FIX command for generating graph

	### ---> move results to public_html
	mv $HIBENCH_HOME/report ~/public_html/report_$timestamp
	chmod -R 755 ~/public_html
done
