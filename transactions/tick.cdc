
import Versus from 0x01cf0e2f2f715450

/*
Simulate that the clock is running
 */
transaction(dropID: UInt64) {
    prepare(account: AuthAccount) {    
      log("CurrentBlock")
      log(getCurrentBlock().height)
      if let versus = account.getCapability(/public/Versus).borrow<&{Versus.PublicDrop}>() {
          let versusStatus=versus.getStatus(dropId: dropID)
          log("Acution end block")
          log(versusStatus.endBlock)
      }
  }
}