import june
proc p() =
  var t = newCustomThread()
  doAssert not t.isNil
p()
