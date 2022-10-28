// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'localization/app_localizations.dart';
import 'models/Bitcoin.dart';
import 'models/TopCoinData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ScrollController? _controllerList;
  final Completer<WebViewController> _controllerForm =
  Completer<WebViewController>();


  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  num _size = 0;
  String? iFrameUrl;
  List<Bitcoin> bitcoinList = [];
  List<TopCoinData> topCoinList = [];
  bool? displayiframeEvo;


  @override
  void initState() {

    _controllerList = ScrollController();
    super.initState();

    // fetchRemoteValue();
    callBitcoinApi();
  }

  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(seconds: 10),
      //   minimumFetchInterval: Duration.zero,
      // ));
      // await remoteConfig.fetchAndActivate();

      await remoteConfig.fetch(expiration: const Duration(seconds: 30));
      await remoteConfig.activateFetched();
      iFrameUrl = remoteConfig.getString('evo_iframeurl').trim();
      displayiframeEvo = remoteConfig.getBool('displayiframeEvo');

      print(iFrameUrl);
      setState(() {

      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callBitcoinApi();

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/frame.png"),fit: BoxFit.fill)),
            child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Start your cryptocurrency campaign with Bitcoin Prime today!",
                              style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                  color:Colors.black,height:1.2),textAlign: TextAlign.left,)
                        ),

                        Padding(padding: EdgeInsets.all(10),
                            child:Text("The Bitcoin Prime app provides cryptocurrency fans with a variety of tools to properly understand cryptocurrencies like Bitcoin. Simply create an account to get going right away.",
                              style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                  color:Color(0xff494b4d),height:1.2),textAlign: TextAlign.left,)
                        ),
                        SizedBox(
                          height:20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height:60,
                            width:170,
                            child: ElevatedButton(
                              onPressed: () {
                                child: WebView(
                                  initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                                  gestureRecognizers: Set()
                                    ..add(Factory<VerticalDragGestureRecognizer>(
                                            () => VerticalDragGestureRecognizer())),
                                  javascriptMode: JavascriptMode.unrestricted,
                                  onWebViewCreated:
                                      (WebViewController webViewController) {
                                    _controllerForm.complete(webViewController);
                                  },
                                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                                  // ignore: prefer_collection_literals
                                  javascriptChannels: <JavascriptChannel>[
                                    _toasterJavascriptChannel(context),
                                  ].toSet(),

                                  onPageStarted: (String url) {
                                    print('Page started loading: $url');
                                  },
                                  onPageFinished: (String url) {
                                    print('Page finished loading: $url');
                                  },
                                  gestureNavigationEnabled: true,
                                );
                              },
                              child: Text( "GET STARTED NOW",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                                  )
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/image/Mask group15.png",alignment: Alignment.bottomRight),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/image/Mask group16.png",alignment: Alignment.topLeft),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration : BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      child:Column(
                                        children: <Widget>[
                                          Image.asset("assets/image/Mask group17.png"),
                                          SizedBox(height: 10,),
                                          Container(
                                            decoration: BoxDecoration(color: Colors.black),
                                            child: Column(
                                              children:[
                                                Padding(padding: EdgeInsets.all(10),
                                                    child:Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("100+",
                                                        style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                                            color:Colors.white,height:1.2),textAlign: TextAlign.left,),
                                                    )
                                                ),
                                                Padding(padding: EdgeInsets.all(10),
                                                    child:Text("cryptos available",
                                                      style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                                          color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                                                ),
                                              ]
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      child:Column(
                                        children: <Widget>[

                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(color: Color(0xff1455fe)),
                                            child: Column(
                                                children:[
                                                  Padding(padding: EdgeInsets.all(10),
                                                      child:Text("10k+",
                                                        style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                                            color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                                                  ),
                                                  Padding(padding: EdgeInsets.all(10),
                                                      child:Text("Users",
                                                        style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                                            color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                                                  ),
                                                ]
                                            ),
                                          ),
                                          SizedBox(height:10,),
                                          Image.asset("assets/image/Mask group18.png"),
                                        ],
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Working with Bitcoin Prime ",
                                    style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left,)
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("Don't you want to become an expert participant who can amass wealth and establish a solid reputation over time? Don't you want to join our network of Bitcoin experts and take advantage of the 2022 crypto bull run? Don't you want to feel the soft tickle of your money increasing? We understood! Join Bitcoin Prime then!",
                                  style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                      color:Color(0xff494b4d),height:1.2),textAlign: TextAlign.left,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("Relied on by 10K+ users",
                                  style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                      color:Colors.black,height:1.2),textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Bitcoin Prime | Our Mission",
                            style:TextStyle(fontSize:35,fontWeight: FontWeight.bold,
                                color:Colors.black,height:1.2),textAlign: TextAlign.left,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset("assets/image/icon1.png",alignment: Alignment.centerLeft,)),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Reduce risks and boost revenue",
                                    style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Our goal is to establish an open crypto environment where both novice and experienced users can prosper.",
                                    style:TextStyle(fontSize:22,
                                        color:Color(0xff5d5d5d),height:1.5),textAlign: TextAlign.left,),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height:15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset("assets/image/icon2.png",alignment: Alignment.centerLeft,)),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Boost your abilities",
                                      style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                          color:Colors.black,height:1.2),textAlign: TextAlign.left),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("You may sharpen your crypto knowledge and engage in Bitcoin and other cryptocurrencies like a pro with the help of our Bitcoin Prime platform.",
                                    style:TextStyle(fontSize:22,
                                        color:Color(0xff5d5d5d),height:1.5),textAlign: TextAlign.left,),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height:15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset("assets/image/icon3.png",alignment: Alignment.centerLeft,)),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Develop a wealth-focused mindset",
                                      style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                          color:Colors.black,height:1.2),textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Create a successful risk management plan and acknowledge that success and failure are just two sides of the same coin.",
                                    style:TextStyle(fontSize:22,
                                        color:Color(0xff5d5d5d),height:1.5),textAlign: TextAlign.left,),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height:15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset("assets/image/icon4.png",alignment: Alignment.centerLeft,)),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Join a like-minded community",
                                      style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                          color:Colors.black,height:1.2),textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("You can join our Bitcoin Prime community from anywhere in the globe by signing up on this Bitcoin Prime homepage, one of the most cutting-edge online platforms.",
                                    style:TextStyle(fontSize:22,
                                        color:Color(0xff5d5d5d),height:1.5),textAlign: TextAlign.left,),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height:15
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("How to Get Started?",
                                    style:TextStyle(fontSize:40,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left),
                              ),
                              SizedBox(
                                height:15,
                              ),
                              Image.asset("assets/image/Mask group20.png"),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("    STEP -1",
                                      style:TextStyle(fontSize:30,
                                          color:Color(0xff9a9a9a),height:1.2),textAlign: TextAlign.left),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("     Open a zero-cost account.",
                                    style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left),
                              ),
                              SizedBox(
                                height:60,
                              ),
                              Image.asset("assets/image/Mask group21.png"),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("    STEP -2",
                                      style:TextStyle(fontSize:30,
                                          color:Color(0xff9a9a9a),height:1.2),textAlign: TextAlign.left),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("     Verify your account.",
                                    style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left),
                              ),
                              SizedBox(
                                height:60,
                              ),
                              Image.asset("assets/image/Mask group22.png"),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("    STEP -3",
                                      style:TextStyle(fontSize:30,
                                          color:Color(0xff9a9a9a),height:1.2),textAlign: TextAlign.left),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("     Get in the crypto world.",
                                    style:TextStyle(fontSize:25,fontWeight: FontWeight.bold,
                                        color:Colors.black,height:1.2),textAlign: TextAlign.left),
                              ),
                              SizedBox(
                                height:30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Are you unsure of the benefits of joining our Bitcoin Prime community? You have the opportunity to control the volatility of the cryptocurrency market with Bitcoin Prime!",
                                style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                    color:Colors.black,height:1.2),textAlign: TextAlign.left),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.black),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text("Join the Bitcoin Prime system right away to watch your account's success seeds grow!",
                                     style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                         color:Colors.white,height:1.2),textAlign: TextAlign.center),
                               ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
  Future<void> callBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
//   var uri = '$URL/Bitcoin/resources/getBitcoinList?size=0';
  var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0';
  // _config ??= await setupRemoteConfig();
  // var uri = _config.getString("bitcoinera_homepageApi"); // ??
  // "http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0";
  //  print(uri);
  var response = await get(Uri.parse(uri));
  //   print(response.body);
  final data = json.decode(response.body) as Map;
  //  print(data);
  if (data['error'] == false) {
    setState(() {
      bitcoinList.addAll(data['data']
          .map<Bitcoin>((json) => Bitcoin.fromJson(json))
          .toList());
      isLoading = false;
      _size = _size + data['data'].length;
    });
  } else {
    //  _ackAlert(context);
    setState(() {});
  }
}

List<Widget> _buildListItem() {
  var list = bitcoinList.sublist(0, 5);
  return list
      .map((e) => InkWell(
    child:Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(style: BorderStyle.solid,color: Colors.white,width:2))),
    child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.zero)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FadeInImage(
                        placeholder:
                        AssetImage('assetsEvo/imagesEvo/cob.png'),
                        image: NetworkImage(
                            // "$URL/Bitcoin/resources/icons/${e.name.toLowerCase()}.png"),
                            "http://45.34.15.25:8080/Bitcoin/resources/icons/${e.name?.toLowerCase()}.png"),
                      ),
                    )
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '${e.name}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                  ],
                ),

                SizedBox(width: 60,),
                // Text(
                //     '${double.parse(e.rate.toString()).toStringAsFixed(2)}',
                //     style: TextStyle(fontSize: 18,color: Colors.black)),
                Center(
                  child: Container(
                    // height: 24,
                    // color: Color(0xFF96EE8F),
                    child: ElevatedButton(
                      // color: Colors.black,
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xff745EE7))
                              )
                          )
                      ),
                      // onPressed: () {
                      //   _controllerList!.animateTo(
                      //       _controllerList!.offset - 850,
                      //       curve: Curves.linear,
                      //       duration: Duration(milliseconds: 500));
                      // },
                      onPressed: () {

                            },
                      child: Padding(padding: EdgeInsets.all(20),
                          child:Text("Trade",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),textAlign: TextAlign.center,
                          )),
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
    ),

    onTap: () {},
  ))
      .toList();
}


  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }
  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setInt("index", 4);
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
  }
}



class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
