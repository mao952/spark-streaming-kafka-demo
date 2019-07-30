package com.sjj.service;

import java.util.Set;

import org.apache.spark.streaming.kafka.OffsetRange;

public interface IOperateHiveWithSpark {

	void getOffset(Set<String> topics);

	void setOffset(OffsetRange offsetRange);

	void launch() throws Exception;
}
