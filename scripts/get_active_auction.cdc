// This script checks that the accounts are set up correctly for the marketplace tutorial.
//

import Auction, Versus from 0x1ff7e32d71183db0

/*
  Script used to get the first active drop in a versus 
 */
pub fun main(address:Address) : Versus.DropStatus?{
    // get the accounts' public address objects
    let account = getAccount(address)

    let versusCap=account.getCapability<&{Versus.PublicDrop}>(/public/Versus)
    if let versus = versusCap.borrow() {
      let versusStatuses=versus.getAllStatuses()
      for s in versusStatuses.keys {
          let status = versusStatuses[s]!
          if status.uniqueStatus.active != false {
            return status
          }
      } 
    } 
  return nil

}
