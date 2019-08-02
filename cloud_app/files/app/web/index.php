<?php

$base_path = dirname(__DIR__);
$route_prefix = getenv("ROUTE_PREFIX");
$class_name = getenv("MAIN_CLASS");
include "../loader.php";

if ($class_name == "")
{
	echo "Hello world !!!";
	exit(0);
}

use Runtime\Collection;
use Runtime\Dict;

global $app;

/* Shutdown function */
register_shutdown_function( function (){
	global $app;
	$error = error_get_last();
	$logs = $app->getLogs();
	if ($error !== NULL && $logs != null && $logs->count() > 0)
	{
		echo "Log:\n";
		echo \Runtime\rs::join("\n", $logs);
	}
});


$env = getenv();
$env['ROUTE_PREFIX'] = isset($_SERVER['HTTP_X_ROUTE_PREFIX']) ? 
	$_SERVER['HTTP_X_ROUTE_PREFIX'] : getenv("ROUTE_PREFIX");
$env['BASE_PATH'] = $base_path;

/* Create context */
$app = Runtime\rtl::newInstance
(
	$class_name,
	Collection::create([ Dict::create($env) ])
);
$app->init();
$app->start();

/* Run request */
$request = \Core\Http\Request::createPHPRequest();
$container = $app->request($request);
if ($container->response)
{
	http_response_code($container->response->http_code);
	if ($container->response->headers != null)
	{
		$keys = $container->response->headers->keys();
		for ($i=0; $i<$keys->count(); $i++)
		{
			$key = $keys->item($i);
			$value = $container->response->headers->item($key);
			header($key . ": " . $value);
		}
	}
	echo $container->response->getContent();
}
else
{
	http_response_code(404);
	echo "404 Not found";
}
