/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "utils/InitResourceUtils.h"
#include "utils/VerifyUtils.h"
#include "resource/Resource.h"
#include "utils/data/collect/DataCollectorManager.h"
#include "client/rmq/RMQNormalConsumer.h"
#include "utils/NameUtils.h"
#include "spdlog/spdlog.h"
#include <iostream>

extern std::shared_ptr<spdlog::logger> multi_logger;
extern std::shared_ptr<Resource> resource;

std::mutex NameUtils::mtx;

std::unordered_map<std::string, std::string> NameUtils::alreadyUsed;

std::atomic<int> RMQNormalConsumer::receivedIndex(0);

std::vector<rocketmq::MQMessageExt> VerifyUtils::msgs;

int initResource(std::shared_ptr<Resource> resource)
{
    const char* grpc_endpoint = std::getenv("GRPC_ENDPOINT");
    const char* namesrv = std::getenv("NAMESERVER");
    const char* brokerAddr = std::getenv("BROKER_ADDR");
    const char* cluster = std::getenv("CLUSTER_NAME");
    const char* accessKey = std::getenv("ACCESS_KEY");
    const char* secretKey = std::getenv("SECRET_KEY");

    if (grpc_endpoint == nullptr || namesrv == nullptr || brokerAddr == nullptr )
    {
        multi_logger->error("Unable to read env variables");
        return 1;
    }

    resource->setGrpcEndpoint(grpc_endpoint);
    resource->setNamesrv(namesrv);
    resource->setBrokerAddr(brokerAddr);
    resource->setCluster((cluster == nullptr | strcmp(cluster, "DefaultCluster") == 0) ? "" : cluster);
    resource->setAccessKey(accessKey == nullptr ? "" : accessKey);
    resource->setSecretKey(secretKey == nullptr ? "" : secretKey);
    resource->setAccessChannel(""); // TODO: set access channel
    return 0;
}