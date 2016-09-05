ansible-nsq
=========

[![Build Status](https://travis-ci.org/ernestas-poskus/ansible-nsq.svg?branch=master)](https://travis-ci.org/ernestas-poskus/ansible-nsq)

NSQ realtime distributed messaging platform Ansible installation role.

![NSQ admin](/assets/nsq_admin_nodes.png)

Installation
------------

ansible-galaxy install ernestas-poskus.nsq

Example Playbook
----------------

```yaml
- name: Installing NSQ
  hosts: all
  sudo: yes
  roles:
    - role: ernestas-poskus.nsq
```

Example for multiple node setup
----------------

```yaml
- name: Installing NSQ
  hosts: nsqs
  sudo: yes
  roles:
    - role: ernestas-poskus.nsq
      nsq_lookupd_tcp_addresses: "{{ groups['nsqs']|map('extract', hostvars, ['ansible_eth1', 'ipv4', 'address'])|list }}"
      nsq_lookupd_http_addresses: "{{ groups['nsqs']|map('extract', hostvars, ['ansible_eth1', 'ipv4', 'address'])|list }}"
```

Requirements
------------

None.

Role Variables
--------------

```yaml
---
# defaults file for ansible-nsq

nsq_nsqd_install: true
nsq_nsqadmin_install: true
nsq_nsqlookupd_install: true

nsq_owner: root
nsq_group: root

nsq_version: 0.3.8
nsq_go_version: go1.6.2
nsq_arch: linux-amd64

nsq_install_directory: /opt

nsq_config_directory: /etc/nsq
nsq_config_directory_mode: 0644

nsq_data_directory: /var/spool/nsq
nsq_data_directory_mode: 0750

nsq_binaries:
  - nsq_pubsub
  - nsq_stat
  - nsq_tail
  - nsq_to_file
  - nsq_to_http
  - nsq_to_nsq
  - to_nsq

nsq_network_interface: "{{ ansible_default_ipv4.interface }}"
nsq_network_ip_protocol: 'ipv4'

nsq_lookupd_tcp_port: 4160
nsq_lookupd_http_port: 4161

nsq_lookupd_tcp_addresses:
  - "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}"

nsq_lookupd_http_addresses:
  - "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}"

nsq_nsqlookupd:
  broadcast_address: "{{ ansible_hostname }}"
  # address of this lookupd node, (default to the OS hostname)
  http_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:{{ nsq_lookupd_http_port }}"
  # <addr>:<port> to listen on for HTTP clients (default "0.0.0.0:4161")
  inactive_producer_timeout: 300s
  # duration of time a producer will remain in the active list since its last ping (default 5m0s)
  tcp_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:{{ nsq_lookupd_tcp_port }}"
  # <addr>:<port> to listen on for TCP clients (default "0.0.0.0:4160")
  tombstone_lifetime: 45s
  # duration of time a producer will remain tombstoned if registration remains (default 45s)

nsq_nsqd:
  auth_http_address:
  #  <addr>:<port> to query auth server (may be given multiple times)
  broadcast_address: "{{ ansible_hostname }}"
  #  address that will be registered with lookupd (defaults to the OS hostname)
  data_path: "{{ nsq_data_directory }}"
  #  path to store disk_backed messages
  deflate: true
  #  enable deflate feature negotiation (client compression) (default true)
  e2e_processing_latency_percentile:
  #  message processing time percentiles (as float (0, 1.0]) to track (can be specified multiple times or comma separated '1.0,0.99,0.95', default none)
  e2e_processing_latency_window_time: 600s
  #  calculate end to end latency quantiles for this duration of time (ie: 60s would only show quantile calculations from the past 60 seconds) (default 10m0s)
  http_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:4151"
  #  <addr>:<port> to listen on for HTTP clients (default "0.0.0.0:4151")
  https_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:4152"
  #  <addr>:<port> to listen on for HTTPS clients (default "0.0.0.0:4152")
  max_body_size: 5242880
  #  maximum size of a single command body (default 5242880)
  max_bytes_per_file: 104857600
  #  number of bytes per diskqueue file before rolling (default 104857600)
  max_deflate_level: 6
  #  max deflate compression level a client can negotiate (> values == > nsqd CPU usage) (default 6)
  max_heartbeat_interval: 60s
  #  maximum client configurable duration of time between client heartbeats (default 1m0s)
  max_msg_size: 1048576
  #  maximum size of a single message in bytes (default 1048576)
  max_msg_timeout: 900s
  #  maximum duration before a message will timeout (default 15m0s)
  max_output_buffer_size: 65536
  #  maximum client configurable size (in bytes) for a client output buffer (default 65536)
  max_output_buffer_timeout: 1s
  #  maximum client configurable duration of time between flushing to a client (default 1s)
  max_rdy_count: 2500
  #  maximum RDY count for a client (default 2500)
  max_req_timeout: 3600s
  #  maximum requeuing timeout for a message (default 1h0m0s)
  mem_queue_size: 10000
  #  number of messages to keep in memory (per topic/channel) (default 10000)
  msg_timeout: 60s
  #  duration to wait before auto_requeing a message (default "1m0s")
  snappy: true
  #  enable snappy feature negotiation (client compression) (default true)
  statsd_address:
  #  UDP <addr>:<port> of a statsd daemon for pushing stats
  statsd_interval: 60s
  #  duration between pushing to statsd (default "1m0s")
  statsd_mem_stats: true
  #  toggle sending memory and GC stats to statsd (default true)
  statsd_prefix: 'nsq.%s'
  #  prefix used for keys sent to statsd (%s for host replacement) (default "nsq.%s")
  sync_every: 2500
  #  number of messages per diskqueue fsync (default 2500)
  sync_timeout: 2s
  #  duration of time per diskqueue fsync (default 2s)
  tcp_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:4150"
  #  <addr>:<port> to listen on for TCP clients (default "0.0.0.0:4150")
  tls_cert:
  #  path to certificate file
  tls_client_auth_policy:
  #  client certificate auth policy ('require' or 'require_verify')
  tls_key:
  #  path to key file
  tls_min_version: 'tls1.0'
  #  minimum SSL/TLS version acceptable ('ssl3.0', 'tls1.0', 'tls1.1', or 'tls1.2') (default 769)
  tls_required: false
  #  require TLS for client connections (true, false, tcp_https)
  tls_root_ca_file:
  #  path to certificate authority file
  worker_id: 255
  #  unique seed for message ID generation (int) in range [0,4096) (will default to a hash of hostname) (default 225)

nsq_nsqadmin:
  graphite_url:
  # graphite HTTP address
  http_address: "{{ hostvars[inventory_hostname]['ansible_' + nsq_network_interface][nsq_network_ip_protocol]['address'] }}:4171"
  # <addr>:<port> to listen on for HTTP clients (default "0.0.0.0:4171")
  http_client_tls_cert:
  # path to certificate file for the HTTP client
  http_client_tls_insecure_skip_verify:
  # configure the HTTP client to skip verification of TLS certificates
  http_client_tls_key:
  # path to key file for the HTTP client
  http_client_tls_root_ca_file:
  # path to CA file for the HTTP client
  notification_http_endpoint:
  # HTTP endpoint (fully qualified) to which POST notifications of admin actions will be sent
  proxy_graphite:
  # proxy HTTP requests to graphite
  statsd_counter_format: 'stats.counters.%s.count'
  # The counter stats key formatting applied by the implementation of statsd. If no formatting is desired, set this to an empty:. (default "stats.counters.%s.count")
  statsd_gauge_format: 'stats.gauges.%s'
  # The gauge stats key formatting applied by the implementation of statsd. If no formatting is desired, set this to an empty:. (default "stats.gauges.%s")
  statsd_interval: '60s'
  # time interval nsqd is configured to push to statsd (must match nsqd) (default 1m0s)
  statsd_prefix: 'nsq.%s'
  # prefix used for keys sent to statsd (%s for host replacement, must match nsqd) (default "nsq.%s")
  template_dir:
  # path to templates directory
```

Dependencies
------------

None.

Testing
------------

You have to install Ruby and VirtualBox for testing in virtual machine.

```bash
gem install bundler
bundle install
bundle exec kitchen test
```

=======

License
-------

Copyright (c) 2016, Ernestas Poskus
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of ansible-nsq nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author Information
------------------

Twitter: @ernestas_poskus
