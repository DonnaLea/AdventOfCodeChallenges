//: Advent of Code 2018: 02 - Inventory Management System (Part 2)
// https://adventofcode.com/2018/day/2

import XCTest

func calculate(input: String) -> String {
  
  let ids = input.split(separator: "\n")
  
  for (i, id) in ids.enumerated() {
    for comparisonId in ids[(i+1)...] {
//      print("comparing: \n\(id) with \n\(comparisonId)")
      var sameChars = ""
      for i in 0..<id.count {
        let index = id.index(id.startIndex, offsetBy: i)
        let comparisonIndex = comparisonId.index(comparisonId.startIndex, offsetBy: i)
        let char = id[index]
        let comparisonChar = comparisonId[comparisonIndex]
        if char == comparisonChar {
          sameChars.append(char)
        }
        if sameChars.count < i-1 {
          break
        }
      }
//      print("same chars: \(sameChars)")
      if sameChars.count == id.count-1 {
        return sameChars
      }
    }
  }
  
  return ""
}

func idsContainingMultiples(ids: [String.SubSequence], multiple: Int) -> [String] {
  var containsMultiples = [String]()
  for id in ids {
    let characters = String(id)
    for char in characters {
      let filteredCharacters = characters.filter { $0 == char }
      let occurances = filteredCharacters.count
      if occurances == multiple {
        containsMultiples.append(String(id))
        break
      }
    }
  }
  
  return containsMultiples
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = """
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
"""
    let value = calculate(input: input)
    XCTAssertEqual(value, "fgij")
  }

}

SequenceTests.defaultTestSuite.run()

let input = """
dghfbsyiznoumojleevappwqtr
dghfbsyiznoumkjljevacpmqer
dghfbbyizioumkjlxevacpwdtr
dghfbsesznoumkjlxevacpwqkr
dghfbsynznoumkjlxziacpwqtr
cghfbsyiznjumkjlxevacprqtr
dghfjsyizwoumkjlxevactwqtr
dghfdsyfinoumkjlxevacpwqtr
hghfbsyiznoumkjlxivacpwqtj
dgcfbsyiznoumkjlxevacbuqtr
dghfbsyiznoymnjlxevacpwvtr
dfhfbsyiznoumkulxevacptqtr
dghfasyiznovmkjlxevacpwqnr
dghfbsyihnouikjlxevackwqtr
dghfbayiznolmkjlyevacpwqtr
jghfbsyiznoumnjldevacpwqtr
dhhfbsyuznoumkjlxevakpwqtr
nehfrsyiznoumkjlxevacpwqtr
dghfbsyiznxdmkolxevacpwqtr
dgpfbsyizwlumkjlxevacpwqtr
yghfbsyiznoumkjlsevacpwqtm
dghfssyiznoumkjlxevvcpwqjr
dahfbsyiznoumkjlfevacpwqto
duhfcsyiznouvkjlxevacpwqtr
dghfbvyiznoumkjlrevacpwvtr
dghfgsyiznoumknlxgvacpwqtr
jghfbeyiznkumkjlxevacpwqtr
daofbsyiznoumkjlxevampwqtr
dghfbsyiznojmkjlxeracpcqtr
dghnbsyiznouokjlxevaclwqtr
dgifbsyiznoumkjlxevnspwqtr
dgkfpsziznoumkjlxevacpwqtr
dghfxsyijnoumkjlxevaccwqtr
dghfbsyiznolmkjlwevzcpwqtr
dkhfbsaiznoumkjlxevacpwqtg
dghfbsygknoumkjlaevacpwqtr
dghfbsyizizumkjlxevacpxqtr
ighfbbyijnoumxjlxevacpwqtr
dghfbsyizrouekjlxevacpwktr
dghobsyiznoujkjlxevacnwqtr
dghpbsyizyoumkjlxeaacpwqtr
dghffsyiznoymkjlxevacewqtr
dghkbssiznoumzjlxevacpwqtr
dghfbsyawnoumkjlxevacpwjtr
drhfbsyiznormkjlfevacpwqtr
dghfbsoiznouwkjlxevacpwqtn
dghfmsyiznoumkjlxlvecpwqtr
dxhfbsyiznoumkjlxeeacvwqtr
dghnbsyiznoumkjsxevacpwqur
dghfbsyiznrujkjlxevacpwqtc
dghfbstoznoumhjlxevacpwqtr
dghfboyiznzumkjlvevacpwqtr
dghfbsyiznjumkjlxevgcpwmtr
dghfbsnizaoumkjlxevacpwetr
dghfbsyirnoumkjoxevacplqtr
dghfbsyiznoumkjlxavvckwqtr
dghfbjdiznoumkjlxevacpwptr
dghfbsywznoumkjlxeiacpwqcr
djhfbsyizuoumkjlxelacpwqtr
dghffsniznoumkjlxpvacpwqtr
dghebsyizuoumkjlxevecpwqtr
rghfbsyiznourkjcxevacpwqtr
dghfbsyignoumkwlxenacpwqtr
dghfbsyiznrufkjlxevacpwqth
dgifbsyiznoumkjlxevacpjqnr
dghfbsyiznoumkjbxevaxpwqtw
dsufbsyizncumkjlxevacpwqtr
dihfbsyiznoumujlxecacpwqtr
dghfbiyiznoumkjlxevajpwqtn
dghqbsyixnoumkjlrevacpwqtr
dghfbsyiznouukjlxeuacpwqtx
dghfbsyizyoumksfxevacpwqtr
dghfbsiiznopfkjlxevacpwqtr
eghfbsyidnoumkjlxexacpwqtr
dghfbgyiznouwkjlwevacpwqtr
dghfbsyyznoumkjlxevacwwqtf
bghfbtypznoumkjlxevacpwqtr
dghfbsyiznoumtjlxebacpwetr
dghfbsgiznonmkplxevacpwqtr
dghfbsyiznoumxjlxevanpwqpr
dghfbsyiznwumujuxevacpwqtr
dghxbsyiznoumkjzxevaypwqtr
dghfbsyhznoumkjlxlvacpiqtr
dghfbsyiznoumkjlxevzcnwqrr
dvhfbsyiznoumkjluevacpzqtr
dghcbsyiznoumkjlxmvacpwetr
dghfbsyiznohmkjvxbvacpwqtr
dghfzsyiznouokjlxevacpwqpr
dghfbsyiznoumkjlxevachtqth
dghfbsyiznoumkjlxjvacpfutr
dghfbsyiznoumkjlxevsppwqtt
dghfusyiznouakhlxevacpwqtr
dghfbsyizcoumkjlxrvaipwqtr
dghebsyipnoumfjlxevacpwqtr
dgdfbsyiznoumkjlwevacpkqtr
dghfbsyiznoumkjlcffacpwqtr
dghfbsypznfumkjlxevacpwqar
dghfbsyiznojmkjlxevgcpkqtr
dghfbsyiznoumkjlaevlcpwstr
dgafrsyiunoumkjlxevacpwqtr
dghfbsyiznouqljlxevacrwqtr
dyhkbsyiznokmkjlxevacpwqtr
pghfbsciznoumkjlxevacpwvtr
dghfbxyiznonmkjllevacpwqtr
ighfbsyizxoumkjlxevacpzqtr
dgffbsyoznoumkjlxevacpwqto
hghfbsyiznoumkjlpevachwqtr
dlhfosyiznoumkjldevacpwqtr
dghfbsvizkoumkjlxvvacpwqtr
dbafbsyiznozmkjlxevacpwqtr
dghfbsyidnoumkjlxrvjcpwqtr
dghfbsyiznfumkjlxeqacpwqta
dghfbsfiznoumkjvxevacjwqtr
dghfbsyimnoumrjlhevacpwqtr
dghflsyiznoumkjlxevacpvqmr
dghfbmfiznoumkjlxevacpdqtr
dghfbsyizsouzkjlxevscpwqtr
dghfksyiznoumimlxevacpwqtr
dghfbsyiznoumkjlxevbwpwqur
wghcbsyiznoumkjlkevacpwqtr
kghfbioiznoumkjlxevacpwqtr
dghfbsiizeoumkjlxmvacpwqtr
dglfbsyilnoumkjlxevpcpwqtr
dgqfbsylznoumkjlxevacpwqcr
dglfhsyiznoumkjlxevacpwqdr
dghfbsymznoumkjlxbvacpwqtb
hghfbsyizhoumkjlxtvacpwqtr
dghdbsyiznoumkjlxeiacpyqtr
dohfbsyiznoumkjmxlvacpwqtr
xhhfbsyiznoumkjlxegacpwqtr
dlhfbsyiznoumkjlxnvahpwqtr
dghfbsyiznovdpjlxevacpwqtr
dgcfbsyiznoumkjlxevactwqdr
dghfksyiknoumkjlxevacpwqcr
ughfqsyiznoumkjlxevacpwctr
dghfbjyiznoumkjlxsvacnwqtr
dgwfbagiznoumkjlxevacpwqtr
dghfbsyiznoumknlxevtcpwqdr
jghfksyiznoumkjlxeoacpwqtr
dghfbsyiznoimkjlwezacpwqtr
dghfbsyiunoumkjlxeqacpwstr
dghfbsyizjoumkwlxevaypwqtr
dghfysriznoumkjlxevucpwqtr
dghfbsygzjoumkjfxevacpwqtr
dghfbhviznoumkjlxevacpwqtq
dghfbsyiznoumkjvwevacpwqur
dghfbsyiznoumtjlxevacplqnr
yghfbsysznouykjlxevacpwqtr
dgwfbsiiznoumkjlxevacfwqtr
dghfbsyizooumkjlxevampiqtr
dshfbsyiznoumkjlxevawpoqtr
dghtbsyxznuumkjlxevacpwqtr
dkhfblyiznoumkjlxevacpaqtr
dgkfbsyiinoumkjlxegacpwqtr
dghfbtxiznouhkjlxevacpwqtr
dghfbsyiznoumkjlxkvmcpeqtr
dghfbsyiznoumkjlghvacpwqmr
dghfbsbizioumkjlcevacpwqtr
dphfbsyizhoumkjwxevacpwqtr
dghfbsyiznqumkjlugvacpwqtr
dghfbsjinnoumkjlxevacpwetr
mghfbsyiznoumkjlxfvacpjqtr
dghfbsxiznoumkjlxetacwwqtr
dghmbsyiznoumbjlxevacpwqyr
dghfbsyiznwumkjlwevacmwqtr
dgkfbsyiznotmkjlxevacpwstr
dghfbsyiznouykjlxeiacuwqtr
dghfbsynznbhmkjlxevacpwqtr
dgyfbsyiznoumtjlbevacpwqtr
dghfbftiznoumkjlxevacpwatr
dghfvsyiznouikjlievacpwqtr
dghfbsyiznodmkjlxevncpwqtz
yfhfbsyiznoumkjluevacpwqtr
dghfbzyiznoumhflxevacpwqtr
dphfbsyizncumkjlxevacpwqtf
dghfasyiznoumkjlxeaicpwqtr
dgffbsyiznoumkjlzevacpwqsr
dghfbsyiznoumkmxxcvacpwqtr
dghffsyiznoumkjlxevacpwqre
dghfbsyizndmmkjlxemacpwqtr
dghfbsviznoamkjlxevappwqtr
dghfbsyiznouckrlxevacpdqtr
dgwfbsyiznyumkjlxevacpqqtr
dujfbsyiznoumgjlxevacpwqtr
dghobsailnoumkjlxevacpwqtr
dghfkqyiznoumknlxevacpwqtr
dghfbyypznoumkjlxevacpwatr
wqhfbsyiznoumkjlxevzcpwqtr
dghfbsyiznoumwjlxrvacppqtr
dghfbsymznoumkflxevacplqtr
dghfbsyiznounkjpgevacpwqtr
ighfbsyijnoumxjlxevacpwqtr
dghfbsyizroumkjllevncpwqtr
dghfbsliznokmkjlxevacpwqtb
dgefbsyiznoumkqlxevpcpwqtr
dghfbtypznouzkjlxevacpwqtr
dmhfbsyiznoumkjlxeyactwqtr
vohfbsyiznoumkjlqevacpwqtr
dgsfpsyiznodmkjlxevacpwqtr
dghfzsyijnoumkjnxevacpwqtr
dghfbayijroumkjlxevacpwqtr
dghfbsyiznodmxjlxgvacpwqtr
dghfbsyiznocmkjlxhvaipwqtr
dghmbsyignoumkjlxevacpoqtr
dghfbsyiznosmkjlncvacpwqtr
dggfbsyiznuumkjlxevacpwqrr
dghibsyilnoumkjlxevacowqtr
dghfbsyiznoumkjluevbcowqtr
dghfbsaiznyuvkjlxevacpwqtr
dgnfxsyiznommkjlxevacpwqtr
dghfbnyiznoumkjlsnvacpwqtr
dghfssiiznoumkjlxavacpwqtr
dghfbsyizneumajlxevacfwqtr
dghfbsyiznoumkjlxevycpvptr
qghfbsyizgoumkjlxevacpwttr
vghfbsyiznoumkjlievaepwqtr
dghfbsyiznoumejlxjvacpwdtr
dghfbsyispoumkjlxevacpwqtg
duhfbsyizpoumkjlxenacpwqtr
dghfbsyifnoumkblxevacpnqtr
bghfbsyxznoumkjleevacpwqtr
dgtfbsyzpnoumkjlxevacpwqtr
dghfbsyiznoumkjlsecacpwqth
dghfqsyiznjumkjlxevawpwqtr
dgcfbsyizboumkjlxevacqwqtr
dghfbqyiznoumkjkxevacpwqtj
dgyfbsyfznoumkjlievacpwqtr
dghfdsyiznoumkplxevacpwdtr
dphfbsyuznkumkjlxevacpwqtr
dghfbsyiznoupkjitevacpwqtr
dghfisyiznoamkjlxevacpwqwr
dgufbsyiznoumkjlxivvcpwqtr
dghfbvyiznoumkjlxevacvwqtz
dghfbsyiqnxumkjlxbvacpwqtr
dghubsyiznqumkflxevacpwqtr
dghfbsyiznzumkjlxevacpdbtr
dghfbsyiznoumkjlxehacpwwrr
mghfbsyiznoumkjlxevacpwqbp
dvhfbryiznoumkclxevacpwqtr
dghbbsyiznotmkjlxevacpwqhr
dghfrsyiznoomkjlxevacpwqto
dghfbkyiznoumkjlxeracpxqtr
dghfbfyizfoumkjlxevacpwjtr
dghfbsyizqoulkjlxevacpwqtt
dghfbsyiwnoumkjlxevacxwgtr
dghfbsyiznormkjlgxvacpwqtr
dghybsyizioumkjoxevacpwqtr
dchfbsyiznoumkjlxyvacpwqtc
dgyfbsyiznouckjlxewacpwqtr
dakfbsyeznoumkjlxevacpwqtr
"""

let value = calculate(input: input)
print(value)
// Correct Answer: ighfbyijnoumxjlxevacpwqtr
