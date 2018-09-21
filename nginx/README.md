# NGINX

## NGINX load-balancing algorithms

*round robin*, *least connection*, *least time*, *IP hash*, and *generic hash*


## Practical Security Tips

### HTTPS Redirects

- Redirect unencrypted requests to HTTPS
- Use a rewrite to send all HTTP traffic to HTTPS

```conf
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    return 301 https://$host$request_uri;
}
```

- This configuration listens on port 80 as the default server for both IPv4 and IPv6 and for any hostname. The return statement returns a 301 permanent redirect to the HTTPS server at the same host and request URI

### Redirecting to HTTPS Where SSL/TLS Is Terminated Before NGINX

- Redirect to HTTPS, however, you’ve terminated SSL/TLS at a layer before NGINX
- Use the standard X-Forwarded-Proto header to determine if you need to redirect

```conf
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    if ($http_x_forwarded_proto = 'http') {
        return 301 https://$host$request_uri;
    }
}
```

- This configuration is very much like HTTPS redirects. However, in this configuration we’re only redirecting if the header X-Forwarded-Proto is equal to HTTP.
- It’s a common use case that you may terminate SSL/TLS in a layer in front of NGINX. One reason you may do something like this is to save on compute costs. However, you need to make sure that every request is HTTPS, but the layer terminating SSL/TLS does not have the ability to redirect. It can, however, set proxy headers. This configuration works with layers such as the Amazon Web Services Elastic Load Balancer, which will offload SSL/TLS at no additional cost. This is a handy trick to make sure that your HTTP traffic is secured.

### HTTP Strict Transport Security

- Use the HTTP Strict Transport Security (HSTS) enhancement by setting the Strict-Transport-Security header

```conf
add_header Strict-Transport-Security max-age=31536000;
```

- This configuration sets the Strict-Transport-Security header to a max age of a year. This will instruct the browser to always do an internal redirect when HTTP requests are attempted to this domain, so that all requests will be made over HTTPS
- For some applications a single HTTP request trapped by a *man in the middle attack* could be the end of the company. If a form  post containing sensitive information is sent over HTTP, the HTTPS redirect from NGINX won’t save you; the damage is done. This optin security enhancement informs the browser to never make an HTTP request, therefore the request is never sent unencrypted

## HTTP Load Balancing

### Problem

You need to distribute load between two or more HTTP servers.

### Solution

Use NGINX’s upstream HTTP module to load balance over HTTP servers
using the upstream block


```conf
upstream backend {
    server 10.10.12.45:80 weight=1; # server is a directive
    server app.example.com:80 weight=2;
}
server {
    location / {
        proxy_pass http://backend;
    }
}
```

This configuration balances load across two HTTP servers on port 80. The weight parameter instructs NGINX to pass twice as many connections to the second server, and the weight parameter defaults to 1.

- upstream module defines a pool of destinations, either a list of Unix sockets, IP addresses, and DNS records, or a mix
- server directive optional parameters include the weight of the server in the balancing algorithm

## TCP Load Balancing

### Problem

You need to distribute load between two or more TCP servers

### Solution

Use NGINX’s stream module to load balance over TCP servers using the upstream block

```conf
stream {
    upstream mysql_read {
        server read1.example.com: 3306 weight = 5;
        server read2.example.com: 3306;
        server 10.10 .12 .34: 3306
        backup;
    }
    server {
        listen 3306;
        proxy_pass mysql_read;
    }
}
```

- The server block in this example instructs NGINX to listen on TCP port 3306 and balance load between two MySQL database read replicas, and lists another as a backup that will be passed traffic if the primaries are down

## Load-Balancing Methods

### Problem

Round-robin load balancing doesn’t fit your use case because you have heterogeneous workloads or server pools.

### Solution

Use one of NGINX’s load-balancing methods, such as least connections, least time, generic hash, or IP hash:

```conf
upstream backend {
    least_conn;
    server backend.example.com;
    server backend1.example.com;
}
```

- This sets the load-balancing algorithm for the backend upstream pool to be least connections. All load-balancing algorithms, with the exception of generic hash, will be standalone directives like the preceding example. Generic hash takes a single parameter, which can be a concatenation of variables, to build the hash from

## Load Balancing Methods

Below are the load-balancing methods are available for upstream HTTP, TCP, and UDP pools

### Round robin

The default load-balancing method, which distributes requests in order of the list of servers in the upstream pool. Weight can be taken into consideration for a weighted round robin, which could be used if the capacity of the upstream servers varies. The higher the integer value for the weight, the more favored the server will be in the round robin. The algorithm behind weight is simply statistical probability of a weighted average. Round robin is the default load-balancing algorithm and is used if no
other algorithm is specified.

### Least connections

Another load-balancing method provided by NGINX. This method balances load by proxying the current request to the upstream server with the least number of open connections proxied through NGINX. Least connections, like round robin, also takes weights into account when deciding to which server to send the connection. The directive name is least_conn

### Least time

Available only in NGINX Plus, is akin to least connections in that it proxies to the upstream server with the least number of current connections but favors the servers with the lowest average response times. This method is one of the most sophisticated load-balancing algorithms out there and fits the need of
highly performant web applications. This algorithm is a value add over least connections because a small number of connections does not necessarily mean the quickest response. The directive name is least_time

### Generic hash

The administrator defines a hash with the given text, variables of the request or runtime, or both. NGINX distributes the load amongst the servers by producing a hash for the current request and placing it against the upstream servers. This method is very useful when you need more control over where requests are sent or determining what upstream server most likely will have the data cached. Note that when a server is added or removed from the pool, the hashed requests will be redistributed. This algorithm has an optional parameter, consistent , to minimize the effect of redistribution. The directive name is hash

## Health Checks

## Slow Start

### Problem

Your application needs to ramp up before taking on full production load

### Solution

Use the slow_start parameter on the server directive to gradually increase the number of connections over a specified time as a server is reintroduced to the upstream load-balancing pool

```conf
upstream {
    zone backend 64 k;
    server server1.example.com slow_start = 20 s;
    server server2.example.com slow_start = 15 s;
}
```

- The server directive configurations will slowly ramp up traffic to the upstream servers after they’re reintroduced to the pool. server1 will slowly ramp up its number of connections over 20 seconds, and server2 over 15 seconds.

- Slow start is the concept of slowly ramping up the number of requests proxied to a server over a period of time. Slow start allows the application to warm up by populating caches, initiating database connections without being overwhelmed by connections as soon as it starts. This feature takes effect when a server that has failed health checks begins to pass again and re-enters the load-balancing pool

## TCP Health Checks

### Problem

You need to check your upstream TCP server for health and remove unhealthy servers from the pool.

### Solution

Use the health_check directive in the server block for an active health check

```conf
stream {
    server {
        listen 3306;
        proxy_pass read_backend;
        health_check interval = 10 passes = 2 fails = 3;
    }
}
```

- The example monitors the upstream servers actively. The upstream server will be considered unhealthy if it fails to respond to three or more TCP connections initiated by NGINX. NGINX performs the check every 10 seconds. The server will only be considered healthy after passing two health checks

- TCP health can be verified by NGINX Plus either passively or actively. Passive health monitoring is done by noting the communication between the client and the upstream server. If the upstream server is timing out or rejecting connections, a passive health check will deem that server unhealthy. Active health checks will initiate their own configurable checks to determine health. Active health checks not only test a connection to the upstream server, but can expect a given response

## HTTP Health Checks

### Problem

You need to actively check your upstream HTTP servers for health

### Solution

Use the health_check directive in a location block

```conf
http {
    server {
        ...
        location / {
            proxy_pass http: //backend;
            health_check interval = 2 s
                         fails = 2
                         passes = 5
                         uri = /
                         match = welcome;
        }
    }#
    status is 200, content type is "text/html", #and body contains "Welcome to nginx!"
    match welcome {
        status 200;
        header Content-Type = text-html;
        body~"Welcome to nginx!";
    }
}
```

## Directives in NGINX

### max_fails, fail_timeout

```conf
upstream ntp {
    server ntp1.example.com: 123 max_fails = 3 fail_timeout = 3 s;
    server ntp2.example.com: 123 max_fails = 3 fail_timeout = 3 s;
}
```

### limit_conn_zone, limit_conn_status, limit_conn

```conf
http {
    limit_conn_zone $binary_remote_addr zone = limitbyaddr: 10m;
    limit_conn_status 429;
    ...
    server {
        ...
        limit_conn limitbyaddr 40;
        ...
    }
}
```

- This configuration creates a shared memory zone named limit byaddr . The predefined key used is the client’s IP address in binary form. The size of the shared memory zone is set to 10 megabytes. The limit_conn directive takes two parameters: a limit_conn_zone name, and the number of connections allowed. The limit_conn_status sets the response when the connections are limited to a status of 429, indicating too many requests. The limit_conn and limit_conn_status directives are valid in the HTTP, server, and location context

### Caching

```nginx
proxy_cache_path /var/nginx/cache
                keys_zone=CACHE:60m
                levels=1:2
                inactive=3h
                max_size=20g;
proxy_cache CACHE;
proxy_cache_key "$host$request_uri $cookie_user";
proxy_cache_bypass $http_cache_bypass;
```

### Cache Performance

You need to increase performance by caching on the client side

```conf
location~ * \.(css | js) $ {
    expires 1 y;
    add_header Cache-Control "public";
}
```

### Purging

You need to invalidate an object from the cache

Use NGINX Plus’s purge feature, the proxy_cache_purge directive, and a nonempty or zero value variable

```conf
map $request_method $purge_method {
    PURGE 1;
    default 0;
}
server {
    ...
    location / {
        ...
        proxy_cache_purge $purge_method;
    }
}
```

## Media Streaming

### Serving MP4 and FLV

Designate an HTTP location block as .mp4 or .flv. NGINX will stream the media using progressive downloads or HTTP pseudostreaming and support seeking

```conf
http {
    server {
        ...
        location /videos/ {
            mp4;
        }
        location~\.flv$ {
            flv;
        }
    }
}
```

- The example location block tells NGINX that files in the videos directory are of MP4 format type and can be streamed with progressive download support. The second location block instructs NGINX that any files ending in .flv are of Flash Video format and can be streamed with HTTP pseudostreaming support

- Streaming video or audio files in NGINX is as simple as a single directive. Progressive download enables the client to initiate playback of the media before the file has finished downloading. NGINX supports seeking to an undownloaded portion of the media in both formats

### NGINX Plus's Module for Media

- Streaming with HLS

```conf
location /hls/ {
    hls;#Use the HLS handler to manage requests

    # Serve content from the following location
    alias /var/www/video;

    #HLS parameters
    hls_fragment 4s;
    hls_buffers 10 10m;
    hls_mp4_buffer_size 1m;
    hls_mp4_max_buffer_size 5m;
}
```

- Streaming with HDS

```conf
location /video/ {
    alias /var/www/transformed_video;
    f4f;
    f4f_buffer_size 512k;
}
```

## UDP Load Balancing

- User Datagram Protocol (UDP) is used in many contexts, such as DNS, NTP, and Voice over IP
- Distribute load between two or more UDP servers

```conf
stream {
    upstream ntp {
        server ntp1.example.com: 123 weight = 2;
        server ntp2.example.com: 123;
    }
    server {
        listen 123 udp;
        proxy_pass ntp;
    }
}
```

## Controlling Access

### Access Based on IP Address

```conf
location /admin/ {
    deny 10.0.0.1;
    allow 10.0.0.0/20;
    allow 2001:0db8::/32;
    deny all;
}
```

- The given location block allows access from any IPv4 address in 10.0.0.0/20 except 10.0.0.1, allows access from IPv6 addresses in the 2001:0db8::/32 subnet, and returns a 403 for requests originating from any other address. The allow and deny directives are valid within the HTTP, server, and location contexts. Rules are checked in sequence until a match is found for the remote address

### Allowing Cross-Origin Resource Sharing

- Serving resources from another domain and need to allow CORS to enable browsers to utilize these resources
- Alter headers based on the request method to enable CORS

```conf
map $request_method $cors_method {
    OPTIONS 11;
    GET 1;
    POST 1;
    default 0;
}
server {
    ...
    location / {
        if ($cors_method~'1') {
            add_header 'Access-Control-Allow-Methods'
                        'GET,POST,OPTIONS';
            add_header 'Access-Control-Allow-Origin'
                        '*.example.com';
            add_header 'Access-Control-Allow-Headers' 
                        'DNT,
                        Keep-Alive,
                        User-Agent,
                        X-Requested-With,
                        If-Modified-Since,
                        Cache-Control,
                        Content-Type ';
        }
        if ($cors_method = '11') {
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain; charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
        }
    }
}
```

-There’s a lot going on in this example, which has been condensed by using a map to group the GET and POST methods together. The OPTIONS request method returns information called a preflight request to the client about this server’s CORS rules. OPTIONS , GET ,and POST methods are allowed under CORS. Setting the Access-Control-Allow-Origin header allows for content being served from this server to also be used on pages of origins that match this header. The preflight request can be cached on the client for 1,728,000 seconds, or 20 days

## Encrypting

### Client-Side Encryption

- Encrypt traffic between your NGINX server and the client
- Utilize one of the SSL modules, such as the ngx_http_ssl_module or ngx_stream_ssl_module to encrypt traffic

```conf
http { # All directives used below are also valid in stream
    server {
        listen 8433 ssl;
        ssl_protocols TLSv1.2;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_certificate /usr/local/nginx/conf/cert.pem;
        ssl_certificate_key /usr/local/nginx/conf/cert.key;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
    }
}
```

- This configuration sets up a server to listen on a port encrypted with SSL, 8443. The server accepts the SSL protocol version TLSv1.2. The SSL certificate and key locations are disclosed to the server for use. The server is instructed to use the highest strength offered by the client while restricting a few that are insecure. The SSL session cache and timeout allow for workers to cache and store session parameters for a given amount of time. There are many other session cache options that can help with performance or security of all types of use cases. Session cache options can be used in conjunction. However,specifying one without the default will turn off that default, built-in session cache

### Upstream Encryption

- Encrypt traffic between NGINX and the upstream service and set specific negotiation rules for compliance regulations or if the upstream is outside of your secured network.
- Use the SSL directives of the HTTP proxy module to specify SSL rules

```conf
location / {
    proxy_pass https://upstream.example.com;
    proxy_ssl_verify on;
    proxy_ssl_verify_depth 2;
    proxy_ssl_protocols TLSv1.2;
}
```

- These proxy directives set specific SSL rules for NGINX to obey. The configured directives ensure that NGINX verifies that the certificate and chain on the upstream service is valid up to two certificates deep. The proxy_ssl_protocols directive specifies that NGINX will only use TLS version 1.2. By default NGINX does not verify upstream certificates and accepts all TLS versions

## RUN

```bash
git clone https://github.com/JinnaBalu/dev-ops.git

cd nginx/

```

### Environment Variables

```bash
docker-compose up -d
```