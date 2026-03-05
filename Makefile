-include .env

build:; forge build

test:; forge test

deploy:; forge script script/DeployFundMe.s.sol --broadcast
fund:; forge script script/Interactions.s.sol --broadcast
deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url ${RPC_URL_SEPOLIA} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY}