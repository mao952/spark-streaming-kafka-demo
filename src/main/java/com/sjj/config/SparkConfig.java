package com.sjj.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SparkConfig {

	@Value("${spark.master}")
	private String sparkMaster;

	@Value("${spark.appName}")
	private String sparkAppName;
}
