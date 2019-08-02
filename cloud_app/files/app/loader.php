<?php

set_time_limit(60);
error_reporting(E_ALL);
ini_set("display_errors", 1);
ini_set("display_startup_errors", 1);
ini_set("track_errors", 1);
ini_set("html_errors", 1);
define("ROOT_PATH", __DIR__);

// Loader

class Loader
{
	
	/**
	 * Try to load file
	 */
	static function tryLoadFile($file_path)
	{
		if (file_exists($file_path))
		{
			include($file_path);
			return true;
		}
		return false;
	}
	
	
	
	/**
	 * Load module
	 */
	static function loadModule($arr1, $arr2)
	{
		$module_name = implode(".", $arr1);
		$file_name = array_pop($arr2);
		$path = implode("/", $arr2);
		if ($path) $path .= "/";
		
		$file_path = ROOT_PATH . "/src/" .
			$module_name . "/php/" . $path . $file_name . ".php";
		//var_dump($file_path);
		if (static::tryLoadFile($file_path))
		{
			return true;
		}
		
		$file_path = ROOT_PATH . "/lib/" . $module_name . "/php/" . $path . $file_name . ".php";
		//var_dump($file_path);
		if (static::tryLoadFile($file_path))
		{
			return true;
		}
		
		return false;
	}
	
	
	
	/**
	 * Load class
	 */
	static function load($name)
	{
		$arr = explode("\\", $name);
		$sz=count($arr);
		$i=1;
		
		while ($i<$sz)
		{
			$arr1 = array_slice($arr, 0, $i);
			$arr2 = array_slice($arr, $i);
			
			if (static::loadModule($arr1, $arr2))
			{
				return true;
			}
			
			$i++;
		}
		
		return false;
	}
	
}

spl_autoload_register([Loader::class, 'load']);