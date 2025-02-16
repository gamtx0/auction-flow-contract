package main

import (
	"github.com/bjartek/go-with-the-flow/gwtf"
	"github.com/mitchellh/go-homedir"
)

func main() {

	flowConfigFile, _ := homedir.Expand("~/.flow-testnet.json")
	flow := gwtf.NewGoWithTheFlow(flowConfigFile)

	//create the versusAdminClientAndSomeOtherCollections
	flow.TransactionFromFile("setup/versus1_testnet").
		SignProposeAndPayAs("versus").
		RunPrintEventsFull()

	//link in the server in the versus client
	flow.TransactionFromFile("setup/versus2_testnet").
		SignProposeAndPayAs("testnet-account").
		AccountArgument("versus").
		RunPrintEventsFull()

	//set up versus
	flow.TransactionFromFile("setup/versus3_testnet").
		SignProposeAndPayAs("versus").
		UFix64Argument("0.15").    //cut percentage,
		UFix64Argument("86400.0"). //length 1day
		UFix64Argument("600.0").   // bump on late bid 10m
		RunPrintEventsFull()

	/*
		now := time.Now()
		t := now.Unix()
		timeString := strconv.FormatInt(t, 10) + ".0"

		image := fileAsImageData("bull.png")

		flow.TransactionFromFile("setup/drop").
			SignProposeAndPayAs("versus").
			AccountArgument("artist").     //marketplace location
			UFix64Argument("10.01").       //start price
			UFix64Argument(timeString).    //start time
			StringArgument("Kinger9999").  //artist name
			StringArgument("CryptoBull2"). //name of art
			StringArgument(image).         //imaage
			StringArgument("An Angry bull").
			Argument(cadence.NewUInt64(10)). //number of editions to use for the editioned auction
			UFix64Argument("5.0").           //min bid increment
			RunPrintEventsFull()


			flow.TransactionFromFile("setup/mint_art").
				SignProposeAndPayAs("versus").
				RawAccountArgument("0x42de7e7e48d17e2a").
				StringArgument("Kinger9999").    //artist name
				StringArgument("CryptoBull0").   //name of art
				StringArgument(image).           //imaage
				StringArgument("An angry bull"). //description
				RunPrintEventsFull()

				flow.TransactionFromFile("buy/bid").
					SignProposeAndPayAs("buyer1").
					AccountArgument("versus").
					Argument(cadence.UInt64(1)).  //id of drop
					Argument(cadence.UInt64(21)). //id of unique auction auction to bid on
					UFix64Argument("10.01").      //amount to bid
					RunPrintEventsFull()

	*/

}
