#!/bin/bash

SWAP_ADMIN=$1

### 独立账号测试

### 重新生成独立测试账号
#aptos key generate --key-type ed25519 --output-file output.key.test

#Testnet测试
#aptos init --profile testnet-test --private-key {output.key.test}  --rest-url https://testnet.aptoslabs.com --skip-faucet

### 钱包手动转gas,测试APT > 5个


### 测试账号接收token
aptos move run --function-id ${SWAP_ADMIN}::CommonHelper::accept_token_entry --type-args ${SWAP_ADMIN}::STAR::STAR --assume-yes --profile  testnet-test
sleep 5

### 给test account 转 STAR，单次转4500个STAR
aptos move run --function-id 0x1::coin::transfer --type-args ${SWAP_ADMIN}::STAR::STAR --args address:0x9bf32e42c442ae2adbc87bc7923610621469bf183266364503a7a434fe9d50ca u64:4500000000000 --profile testnet-admin --assume-yes
sleep 5


### 触发一次swap交易
aptos move run --function-id 'testnet-admin::TokenSwapScripts::swap_exact_token_for_token' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin  --args u128:200000000000 u128:100 --assume-yes --profile  testnet-test
sleep 5

### 再触发一次swap交易，另一个交易对
aptos move run --function-id 'testnet-admin::TokenSwapScripts::swap_exact_token_for_token' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin  --args u128:100000000000 u128:100 --assume-yes --profile  testnet-test
sleep 5

### 测试添加流动性
aptos move run --function-id 'testnet-admin::TokenSwapScripts::add_liquidity' --type-args ${SWAP_ADMIN}::STAR::STAR     0x1::aptos_coin::AptosCoin   --args  u128:1200000000000  u128:300000000  u128:5000  u128:5000  --profile testnet-test --assume-yes
sleep 5

### 质押流动性
aptos move run --function-id 'testnet-admin::TokenSwapFarmScript::stake' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin --args  u128:26655101   --profile  testnet-test --assume-yes
sleep 5

### 领取奖励
aptos move run --function-id 'testnet-admin::TokenSwapFarmScript::harvest' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin --args  u128:0   --profile  testnet-test --assume-yes
sleep 5


### 取出Farm质押
aptos move run --function-id 'testnet-admin::TokenSwapFarmScript::unstake' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin  --args  u128:3100   --profile  testnet-test --assume-yes
sleep 5

### 质押Syrup
aptos move run --function-id 'testnet-admin::TokenSwapSyrupScript::stake' --type-args ${SWAP_ADMIN}::STAR::STAR  --args  u64:100 u128:12000000000   --profile  testnet-test --assume-yes
sleep 5

aptos move run --function-id 'testnet-admin::TokenSwapSyrupScript::stake' --type-args ${SWAP_ADMIN}::STAR::STAR  --args  u64:3600 u128:25000000000   --profile  testnet-test --assume-yes
sleep 5

### 给farm池boost加速
aptos move run --function-id 'testnet-admin::TokenSwapFarmScript::boost' --type-args ${SWAP_ADMIN}::STAR::STAR 0x1::aptos_coin::AptosCoin  --args  u128:1445965   --profile  testnet-test --assume-yes
sleep 5

### syrup unstake
aptos move run --function-id 'testnet-admin::TokenSwapSyrupScript::unstake' --type-args ${SWAP_ADMIN}::STAR::STAR  --args  u64:1   --profile  testnet-test --assume-yes
sleep 5