//This contract is on purpose pretty simple, it does not have a minter on anything
//It should probably not be as loose permission wise at it is now.

import NonFungibleToken from 0x01cf0e2f2f715450

pub contract Art: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Created(id: UInt64, metadata: {String: String})

    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64

        //TODO: use trait/mixin proposal for the below items
        //TODO: StorageCapability, StorageItems
        //TODO: item to getData()
        //TODO: OriginalArtistRoyalty
        pub var metadata: {String: String}

        init(initID: UInt64, metadata: {String: String}) {
            self.id = initID
            self.metadata = metadata
        }
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        // deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @Art.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    // public function that anyone can call to create a new empty collection
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }


	// mintNFT mints a new NFT with a new ID
	pub fun createArt(_ metadata: {String: String}) : @Art.NFT {

        var newNFT <- create NFT(initID: Art.totalSupply, metadata: metadata)
        emit Created(id: Art.totalSupply, metadata: metadata)

        Art.totalSupply = Art.totalSupply + UInt64(1)
        return <- newNFT
	}

	init() {
        // Initialize the total supply
        self.totalSupply = 0
        emit ContractInitialized()
	}
}

 