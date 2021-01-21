import FungibleToken from 0xee82856bf20e2aa6
import NonFungibleToken, DemoToken, Art from 0x01cf0e2f2f715450
/*
Setup an address with an empty NFT collection and a FT vault with the given amount of tokens.
Used purely for demo purposes    
 */
transaction(tokens:UFix64) {

    prepare(acct: AuthAccount) {

        let reciverRef = acct.getCapability(/public/DemoTokenReceiver)
        //If we have a DemoTokenReceiver then we are already set up so just return
        if reciverRef.check<&{FungibleToken.Receiver}>() {
            log("Account already initalized")
            return
        }

        // create a new empty Vault resource
        let vaultA <- DemoToken.createVaultWithTokens(tokens)

        // store the vault in the accout storage
        acct.save<@FungibleToken.Vault>(<-vaultA, to: /storage/DemoTokenVault)

        // create a public Receiver capability to the Vault
        acct.link<&{FungibleToken.Receiver}>( /public/DemoTokenReceiver, target: /storage/DemoTokenVault)

        // create a public Balance capability to the Vault
        acct.link<&{FungibleToken.Balance}>( /public/DemoTokenBalance, target: /storage/DemoTokenVault)

        // store an empty NFT Collection in account storage
        acct.save<@NonFungibleToken.Collection>(<- Art.createEmptyCollection(), to: /storage/ArtCollection)

        // publish a capability to the Collection in storage
        acct.link<&{NonFungibleToken.CollectionPublic}>(/public/ArtCollection, target: /storage/ArtCollection)
      
    }

}
 