This repository is about monitoring Junos devices using a TIG stack (Telegraf-Influxdb-Grafana).  
It has automation content to monitor Junos devices using a TIG stack.  
It has ready to use content to monitor interfaces and BGP and other system details (uptime, ...).    
It currently supports data collection on Junos using SNMP and OpenConfig.  

Please visit the [**wiki**](https://github.com/ksator/junos_monitoring_with_a_TIG_stack/wiki) for detailled instructions.  

Here are some Grafana screenshots, with data collected using Openconfig telemetry (GRPC) on Junos devices:

![EBGP_peers_configured.png](resources/EBGP_peers_configured.png)

![BGP_sessions_state_established.png](resources/BGP_sessions_state_established.png)

![transitions_to_bgp_established.png](resources/transitions_to_bgp_established.png)

![BGP_prefixes_received.png](resources/BGP_prefixes_received.png)

![BGP_prefixes_sent.png](resources/BGP_prefixes_sent.png)



