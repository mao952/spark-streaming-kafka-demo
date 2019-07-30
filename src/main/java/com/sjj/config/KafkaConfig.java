package com.sjj.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KafkaConfig {

	@Value("${kafka.broker}")
	private String kafkaBroker;

	@Value("${kafka.topic}")
	private String kafkaTopic;
	
}
