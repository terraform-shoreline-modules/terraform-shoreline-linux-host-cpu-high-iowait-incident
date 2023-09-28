sudo tcpdump -i ${INTERFACE} -nn -s0 -v port ${PORT} -w tcpdump.pcap &

sudo timeout ${DURATION} sudo tcpdump -i ${INTERFACE} -nn -s0 -v port ${PORT}

sudo killall tcpdump