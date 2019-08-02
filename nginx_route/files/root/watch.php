<?php


class Work
{
	
	/**
	 * Returns User Agent
	 */
	public static function getUserAgent()
	{
		return 'PHP-client/1.0';
	}
	
	
	
	/**
	 * Returns consul host
	 */
	public static function getConsulHost()
	{
		return "http://consul:8500";
	}
	
	
	
	/**
	 * Returns /v1/agent/checks
	 */
	public static function getAgentChecksUrl()
	{
		return static::getConsulHost() . "/v1/agent/checks";
	}
	
	
	
	/**
	 * Returns /v1/catalog/service/<SERVICE_NAME>
	 */
	public static function geServiceInfoUrl($service_name)
	{
		return static::getConsulHost() . "/v1/catalog/service/" . $service_name;
	}
	
	

	/**
	 * Send curl
	 */
	public function curl($url, $post = null, $headers = null)
	{
		var_dump($url);
		
		# Сохраняем дескриптор сеанса cURL
		$curl = curl_init();
		
		# Устанавливаем необходимые опции для сеанса cURL
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_USERAGENT, static::getUserAgent());
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
		curl_setopt($curl, CURLOPT_HEADER, false);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
		
		if ($post != null)
		{
			curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'POST');
			curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post));
		}
		else
		{
			curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'GET');
		}
		
		if ($headers != null && count($headers) > 0)
		{
			curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		}
		
		# Инициируем запрос к API и сохраняем ответ в переменную
		$out = curl_exec($curl);
		
		# Получим HTTP-код ответа сервера
		$code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		
		# Завершаем сеанс cURL
		curl_close($curl); 
		
		$response = null;
		$code = (int)$code;
		if ($code == 200 || $code == 204)
		{
			$response = @json_decode($out, true);
		}
		else
		{
			throw new \Exception("HTTP Response error");
		}
		
		return [$out, $code, $response];
	}

	
	
	/**
	 * Returns services
	 */
	public function getServices()
	{
		$res = [];
		list($out, $code, $services) = $this->curl( static::getAgentChecksUrl() );
		
		$services = array_filter
		(
			$services,
			function ($item)
			{
				return $item['Status'] == 'passing' && in_array("nginx_route", $item['ServiceTags']);
			}
		);
		
		
		foreach ($services as $service)
		{
			$service_id = $service['ServiceID'];
			$service_name = $service['ServiceName'];
			
			list($out, $code, $services_info) = $this->curl( static::geServiceInfoUrl($service_name) );
			
			foreach ($services_info as $info)
			{
				if ($info['ServiceID'] != $service_id) continue;
				
				$ip = $info['ServiceAddress'];
				$meta = $info['ServiceMeta'];
				$route_prefix = isset($meta['ROUTE_PREFIX']) ? $meta['ROUTE_PREFIX'] : null;
				
				if ($route_prefix == null) continue;
				
				if (!isset($res[$service_name]))
				{
					$res[$service_name] = [
						'service_name' => $service_name,
						'route_prefix' => $route_prefix,
						'ip' => [],
					];
				}
				
				$res[$service_name]['route_prefix'] = $route_prefix;
				$res[$service_name]['ip'][] = $ip;
			}
		}
		
		return $res;
	}
	
	
	
	/**
	 * Output nginx upstream config by service
	 */
	public function nginxUpstream($service)
	{
		$servers = array_map(
			function ($item){ return $item; },
			$service['ip']
		);
		$servers = array_filter(
			$servers,
			function ($item){ return $item != ""; }
		);
		if (count($servers) == 0) return "";
		
		$servers = array_map(
			function ($item){ return "server " . $item . ";"; },
			$service['ip']
		);
		
		$servers = implode("\n", $servers);
		$template="upstream {$service['service_name']}\n{\n".$servers."\n}";
		return $template;
	}
	
	
	
	/**
	 * Output nginx upstream config
	 */
	public function nginxUpstreams($services)
	{
		$templates = array_map(
			[$this, 'nginxUpstream'],
			$services
		);
		$template = implode("\n", $templates);
		return $template;
	}
	
	
	
	/**
	 * Output nginx routes
	 */
	public function nginxRoutes($services)
	{
		$templates = array_map(
			function($service)
			{
				$service_name = $service['service_name'];
				$route_prefix = $service['route_prefix'];
				return "location ".$route_prefix."/
{
proxy_pass http://".$service_name."/;
proxy_set_header X-ROUTE-PREFIX ".$route_prefix.";
include inc/proxy.inc;
}";
			},
			$services
		);
		$template = implode("\n", $templates);
		return $template;
	}
	
	
	
	/**
	 * File save
	 */
	public function fileSave($file, $new_content)
	{
		$old_content = file_get_contents($file);
		if ($old_content != $new_content)
		{
			file_put_contents($file, $new_content);
			return true;
		}
		
		return false;
	}
	
	
	
	/**
	 * Nginx reload
	 */
	public function nginxReload()
	{
		echo "Reload nginx\n";
		system("/usr/sbin/nginx -s reload");
	}
	
	
	
	/**
	 * Go
	 */
	public function go()
	{
		$services = $this->getServices();
		$upstreams = $this->nginxUpstreams($services);
		$routes = $this->nginxRoutes($services);
		
		$is_changed = false;
		$res = $this->fileSave("/etc/nginx/app/routes.inc", $routes); $is_changed = $is_changed || $res;
		$res = $this->fileSave("/etc/nginx/app/upstreams.inc", $upstreams); $is_changed = $is_changed || $res;
		
		if ($is_changed)
		{
			$this->nginxReload();
		}
	}
	
}


$work = new Work();
$work->go();
