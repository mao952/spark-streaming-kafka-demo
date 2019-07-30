package com.sjj.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HadoopConfig {

	@Value("${hadoop.user}")
	private String hadoopUser;
}
