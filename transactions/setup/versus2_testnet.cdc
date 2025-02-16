

//local emulator

//these are testnet 
import FungibleToken from 0x9a0766d93b6608b7
import NonFungibleToken from 0x631e88ae7f1d7c20
import Content, Art, Auction, Versus from 0x467694dd28ef0a12

//This transactions is run as the owner of the versus contract and links in the client
//ownerAddress is the address that will host the marketplace
transaction(ownerAddress: Address) {

    //versus account
    prepare(account: AuthAccount) {

        let owner= getAccount(ownerAddress)
        let client= owner.getCapability<&{Versus.VersusAdminClient}>(Versus.VersusAdminClientPublicPath)
                .borrow() ?? panic("Could not borrow admin client")

        let versusAdminCap=account.getCapability<&Versus.Administrator>(Versus.VersusAdministratorPrivatePath)
        client.addCapability(versusAdminCap)


        let artClient=owner.getCapability<&{Art.AdministratorClient}>(Art.AdministratorPublicPath)
            .borrow() ?? panic("Could not borrow art admin client")
        let minter=account.getCapability<&Art.Minter>(Art.MinterPrivatePath)
        artClient.addCapability(minter)

    }
}
 