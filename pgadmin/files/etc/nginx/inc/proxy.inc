proxy_set_header  HOST               $host;
proxy_set_header  Referer            $http_referer;
proxy_set_header  X-Real-IP          $remote_addr;
proxy_set_header  X-Forwarded-For    $proxy_add_x_forwarded_for;
proxy_set_header  X-Forwarded-Proto  $scheme;
proxy_set_header  X-Forwarded-Port   $server_port;