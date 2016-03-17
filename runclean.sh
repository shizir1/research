#github
#workload size
#!/bin/bash +vx
HADOOP_HOME=/var/work/shizir1/hadoop-1.2.1
SPARK_HOME=/var/work/shizir1/spark-1.6.0-bin-hadoop1
HIBENCH_HOME=/var/work/shizir1/HiBench
timestamp=$(date +%s)

$HADOOP_HOME/bin/stop-all.sh
$SPARK_HOME/sbin/stop-all.sh

# Sanirim buarkadas ve hadoop format (commands'in icindeki) calismiyor. Yarin bakariz.
cp -r $HIBENCH_HOME/report/hibench.report $HIBENCH_HOME/hibench.report_$timestamp

for machines in `cat $1`
do 
   #for loop 1 - 10
   #hibench reportu yedekle
   #clean
   ssh $machines 'bash -s' < $2
done

sleep 10

#hadoop baslat ./start-all.sh
$HADOOP_HOME/bin/start-all.sh
$SPARK_HOME/sbin/start-all.sh

sleep 60

echo "---> Running the tests:"
$HIBENCH_HOME/bin/run-all.sh

