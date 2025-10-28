import 'package:flutter/material.dart';

import 'colors.dart';

String getBankNameFromCorpCode(String corpCode) {
  // Map corpcode to bank name
  final Map<String, String> corpCodeToBankName = {
    "BNKKRMR": "KURUMATHUR SERVICE CO OPERATIVE BANK LTD",
    "BNKPDVR": "PIDAVOOR SCB",
    "BNKKNPRM": "Kannapuram SCB",
    "BNKTRK": "Thrikkakkara SCB",
    "BNKKVRY": "KOOVERY SERVICE CO OPERATIVE BANK LTD",
    "BNKKPM": "Kaipamangalam SCB",
    "BNKKPMF": "Kaipamangalam Fisherman SCB",
    "BNKPRK": "Peringottukara SCB",
    "BNKPYPL": "POOYAPALLY SCB",
    "BNKVLMK": "VELIMUKKU SCB",
    "BNKPLKL": "PALLICKAL SCB",
    "BNKCRKT": "CHERUKALATHUR SCB",
    "BNKCLNR": "CHELANNUR SERVICE CO OPERATIVE BANK",
    "BNKPPNS": "Pappinissery Rural Bank",
    "BNKELYR": "ELAYAVOOR SERVICE CO OPERATIVE BANK LTD",
    "BNKKTM": "KOTTAYAM SERVICE CO OPERATIVE BANK LTD",
    "BNKAVN": "Avinissery SCB",
    "BNKDMDM": "DHARMADAM SERVICE CO OPERATIVE BANK LTD",
    "BNKPTVM": "PATTUVAM SERVICE CO OPERATIVE BANK",
    "BNKKUTGM": "KUTTUMUGHAM SERVICE CO OPERATIVE BANK LTD",
    "BNKERKT": "ERAMAM KUTTUR SERVICE CO OPERATIVE BANK LTD",
    "BNKKDKD": "KODAKKAD SERVICE CO OPERATIVE BANK LTD",
    "BNKPMP": "PMP SERVICE CO OPERATIVE BANK",
    "BNKSKMB": "SRI KAMBILAYA MUTUAL NIDHI LIMITED",
    "BNKTSSCB": "Thuravoor South SCB",
    "BNKVBGR": "VIBGYOR NIDHI LIMITED",
    "BNKPPL": "PERUMPILLY SCB",
    "BNKKTRM": "KAITHARAM SCB",
    "BNKKZPL": "KUZHUPPILLY SCB",
    "BNKNABL": "NAYARAMBALAM SCB",
    "BNKELR": "ELOOR SCB",
    "BNKERYD": "ERIYAD SCB",
    "BNKPYVR": "PAYYAVOOR SCB",
    "BNKVDKRA": "VADAKKEKKARA SCB",
    "BNKPRVR": "PARAVUR SCB",
    "BNKVLLR": "Velloor Service Co Operative Bank",
    "BNKMANK": "Manakunnam SCB",
    "BNKAZKD": "AZHIKODE SCB",
    "BNKTHRNL": "Thirunaloor SCB",
    "BNKVDYR": "VADAYAR",
    "BNKKDKPL": "KADAKKARAPALLY SCB",
    "BNKUCMSA": "URBAN CARE MULTI STATE AGRO CSL",
    "BNKKKYR": "KOKKAYAR SCB",
    "BNKMFF": "MILK FARMERS AND FISHERIES",
    "BNKCORDL": "Cordial Gramin Development Foundation",
    "BNKCHLVR": "CHELAVUR SCB",
    "BNKVRND": "VARANAD SCB",
    "BNKVBGRK": "VIBGYOR NIDHI LIMITED KOOTTILANGADI",
    "BNKKNKRA": "KUNNUKARA SCB",
    "BNKEDVNKD": "EDAVANAKKAD",
    "BNKKRDM": "KARTHEDOM SCB",
    "BNKAROOR": "AROOR SCB",
    "BNKGMSA": "Gramin Multi State Agro Co Operative Society Ltd",
    "BNKICCSL": "Indian Cooperative Credit Society Limited",
    "BNKNNDR": "Neendoor scb",
    "BNKCOB": "Co operative bhavan",
    "BNKCHMG": "Chathamangalam SCB",
    "BNKCXTX": "COXTAX",
    "BNKORNTL": "ORIENTAL AGRO MULTISTATE CO OP SOCIETY",
    "BNKTSRA": "Thushara Nidhi",
    "BNKPRTR": "PURATHUR SCB",
    "BNKCLBT": "CLUB T",
    "BNKPNP": "Pearls N Petals",
    "BNKVLKD": "Vellarkkad SCB",
    "BNKMDS": "Medi Soft",
    "BNKPLSCB": "Pulakode service cooperative Bank",
    "BNKMNCHL": "MEENACHIL SCB",
    "BNKOMSRY": "Omassery SCB",
    "BNKPTKL": "Pothukal SCB",
    "BNKFPMC": "FAPMCO MSCS",
    "BNKMULKD": "Mullakkodi Co-operative Bank",
  };

  // Return the bank name if found, otherwise return a default value
  return corpCodeToBankName[corpCode] ?? "Unknown Bank";
}


void showProgressDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child:const Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: home2),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please wait....",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
