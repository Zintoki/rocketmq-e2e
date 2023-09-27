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
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package org.apache.rocketmq.enums;

public class TESTSET {
    public static final String SMOKE = "smoke";

    /**
     * delay message
     */
    public static final String DELAY = "delay";
    /**
     * normal message
     */
    public static final String NORMAL = "normal";
    /**
     * order message
     */
    public static final String ORDER = "order";
    /**
     * transaction message
     */
    public static final String TRANSACTION = "transaction";

    public static final String PULL = "pull";
    public static final String BATCH_CONSUME = "batchConsume";
    public static final String DEADLETTER = "deadletter";
    public static final String REBALANCE = "rebalance";
    public static final String CLIENT = "client";
    public static final String RETRY = "retry";
    public static final String ASNYC = "async";
    public static final String TAG = "tag";
    public static final String SQL = "sql";
    public static final String CLUSTER = "cluster";
    public static final String BROADCAST = "broadcast";
    public static final String ACL = "acl";
    public static final String MODEL = "model";
}
