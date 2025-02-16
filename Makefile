all: demo

#run the demo script on devnet
.PHONY: demo
demo: deploy
	go run ./tasks/demo/main.go

.PHONY: marketplace
marketplace: deploy
	go run ./tasks/marketplace/main.go

#this goal deployes all the contracts to emulator
.PHONY: deploy
deploy:
	flow project deploy  -n emulator


#this goal mints new flow tokens on emulator takes an account(Addres) env and can take an amount(int:100) env
.PHONY:mint
mint:
	go run ./tasks/mint/main.go


#this goal transfers funds on testnet required an account(Address) env and can take an amount(int:100) env
.PHONY: transfer
transfer:
	go run ./tasks/transfer/main.go

#this goal settles and drop on testnet requires a drop(int) argument
.PHONY: settle
settle:
	go run ./tasks/settle/main.go

#this goal creates and example drop on testnet, requires drop(string) env that will be used as NFT name suffix
.PHONY: drop
drop:
	go run ./tasks/drop/main.go

#set up the marketplace on testnet
.PHONY: testnet
testnet:
	go run ./tasks/testnet/main.go
