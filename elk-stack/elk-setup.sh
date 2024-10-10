#!/bin/bash
sudo dnf update -y
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.17.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.17.0.rpm
sudo rpm --install elasticsearch-7.17.0-x86_64.rpm
sudo rpm --install kibana-7.17.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.17.0.rpm
sudo systemctl enable elasticsearch --now
sudo systemctl enable kibana --now
sudo systemctl enable logstash --now
sudo sed -i 's/#network.host: .*/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#server.host: .*/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sudo sed -i 's|#elasticsearch.hosts: \["http://localhost:9200"\]|elasticsearch.hosts: ["http://localhost:9200"]|' /etc/kibana/kibana.yml
sudo systemctl restart elasticsearch
sudo systemctl restart kibana









