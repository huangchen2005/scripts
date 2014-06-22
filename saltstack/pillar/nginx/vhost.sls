vhost:
  {% if 'lens' in grains['id'] %}
  - name: newlens-api.networkbench.com.conf
    target: /opt/nginx/conf/vhost/newlens-api.networkbench.com.conf
    source: salt://nginx/files/vhost/newlens-api.networkbench.com.conf
  - name: lens
    target: /opt/nginx/conf/vhost/lens.networkbench.com.conf
    source: salt://nginx/files/vhost/lens.networkbench.com.conf
  {% endif %}
