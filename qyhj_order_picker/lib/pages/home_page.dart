import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qyhj_order_picker/components/home_tab_component/tab_0.dart';
import 'package:qyhj_order_picker/components/home_tab_component/tab_1.dart';
import 'package:qyhj_order_picker/components/home_tab_component/tab_2.dart';
import 'package:qyhj_order_picker/components/loading_widget.dart';
import 'package:qyhj_order_picker/module/printer_info.dart';
import 'package:qyhj_order_picker/print_style/container_box/receipt_constrained_box.dart';
import 'package:qyhj_order_picker/print_style/demo/receipt_temp_demo.dart';
import 'package:qyhj_order_picker/print_style/receipt_temp.dart';
import 'package:qyhj_order_picker/utils/net/http_util.dart';
// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

// import 'package:qyhj_order_picker/utils/tts_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List dataArr0 = [];
  List dataArr1 = [];
  List dataArr2 = [];

  PrinterInfo? currentSelectPrinter;
  late Timer _timer;
  @override
  void initState() {
    debugPrint("home page == >> 进来了");
    // TODO: implement initState
    super.initState();
    _getData();
    _getData2();
    _getData3();

    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _getData();
    });
  }

  _getData() async {
    var response = await HttpUtil().get(
        "/employeecardpc/welfare/listWelfareOrder",
        data: {"keywords": "", "status": 1, "page": 1, "page_size": 200,"start_time":"","end_time":""});
    var resData = json.decode(response.toString());
    // debugPrint("获取订单列表0===>>$resData");
    setState(() {
      dataArr0 = resData['data']['data'];
    });

    var printData = [];
    for (var i = 0; i < dataArr0.length; i++) {
      if (dataArr0[i]["print_status"] == 1) {
        printData.add(dataArr0[i]);
      }
    }
    if (printData.isNotEmpty) {
      if (currentSelectPrinter == null) {
        // Fluttertoast.showToast(msg: "存在待打印的订单信息，请选择打印设备");
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("提示"),
                  content: Text("存在待打印的订单信息，请选择打印设备"),
                ));
        return;
      }
      for (var i = 0; i < printData.length; i++) {
        PictureGeneratorProvider.instance.addPicGeneratorTask(
          PicGenerateTask<PrinterInfo>(
            tempWidget: ReceiptConstrainedBox(
              ReceiptStyleWidget(
                dataDic: printData[i],
              ),
              pageWidth: 350,
            ),
            printTypeEnum: PrintTypeEnum.receipt,
            params: currentSelectPrinter,
          ),
        );
      }

      await HttpUtil().post("/employeecardpc/welfare/printOrder", data: {
        "out_trade_no": printData.map((e) => e["out_trade_no"]).toList()
      });
    }
  }

  _getData2() async {
    var response = await HttpUtil().get(
        "/employeecardpc/welfare/listWelfareOrder",
        data: {"keywords": "", "status": 2, "page": 1, "page_size": 200,"start_time":"","end_time":""});
    var resData = json.decode(response.toString());
    // debugPrint("获取订单列表0===>>$resData");
    setState(() {
      dataArr1 = resData['data']['data'];
    });
  }

   _getData3() async {
    var response = await HttpUtil().get(
        "/employeecardpc/welfare/listWelfareOrder",
        data: {"keywords": "", "status": 3, "page": 1, "page_size": 200,"start_time":"","end_time":""});
    var resData = json.decode(response.toString());
    // debugPrint("获取订单列表0===>>$resData");
    setState(() {
      dataArr2 = resData['data']['data'];
    });
  }

  // void cancelTap(index) {
  //   debugPrint("cancel tap===>>$index");
  //   // TTSUtil.sharedInstance().speak("来新订单了，请注意查收");
  // }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "前言后记",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Text("打印机"),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 54,
            child: TabBar(
              tabs: const [
                Tab(
                  text: "待制作",
                ),
                Tab(
                  text: "待取货",
                ),
                Tab(
                  text: "已完成",
                )
              ],
              controller: tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Tab0(
                  data: dataArr0,
                  inspectTap: (index) {
                    if (currentSelectPrinter == null) {
                      // Fluttertoast.showToast(msg: "请选择打印设备");
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text("提示"),
                                content: Text("请选择打印设备"),
                              ));
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ReceiptTempWidget(currentSelectPrinter!,
                          dataDic: dataArr0[index], receiptWidth: 350);
                    }));
                  },
                  checkTap: (index) async {
                    debugPrint("check tap ====>>$index");
                    //制作完成，改变状态
                    var response = await HttpUtil().post(
                        "/employeecardpc/welfare/updateWelfareOrderStatus",
                        data: {
                          "out_trade_no": dataArr0[index]["out_trade_no"],
                          "status": 2
                        });
                    var resData = json.decode(response.toString());
                    if (resData['code'].toString() == '200') {
                      setState(() {
                        dataArr0.removeAt(index);
                        _getData2();
                      });
                    }
                  },
                ),
                Tab1(
                  data: dataArr1,
                  checkTap: (index) async{
                    //已提货，改变状态
                    var response = await HttpUtil().post(
                        "/employeecardpc/welfare/updateWelfareOrderStatus",
                        data: {
                          "out_trade_no": dataArr1[index]["out_trade_no"],
                          "status": 3
                        });
                    var resData = json.decode(response.toString());
                    if (resData['code'].toString() == '200') {
                      setState(() {
                        dataArr1.removeAt(index);
                        _getData3();
                      });
                    }
                  },
                ),
                Tab2(
                  data: dataArr2,
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
          ),
          child: const Icon(
            Icons.refresh_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      endDrawer: Drawer(
        width: 540,
        child: FutureBuilder(
          future: queryPrinter(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                //查询出错了
                return const Center(
                  child: Text('查询出错了'),
                );
              } else {
                return _printerList(snapshot.data);
              }
            } else {
              return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }

  //查询本地USB打印机列表
  Future<List<PrinterInfo>> queryLocalUSBPrinter() {
    return FlutterPrinterFinder.queryUsbPrinter().then(
      (value) => value.map((e) => PrinterInfo.fromUsbDevice(e)).toList(),
    );
  }

  Future<List<PrinterInfo>> queryPrinter() {
    return queryLocalUSBPrinter();
  }

  Widget _printerList(List<PrinterInfo> data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (BuildContext context, int index) {
          return _PrinterItemWidget(
            data[index],
            selectPrinter: (PrinterInfo printer) {
              currentSelectPrinter = printer;
              _getData();
            },
          );
        },
      ),
    );
  }
}

class _PrinterItemWidget extends StatelessWidget {
  final PrinterInfo printerInfo;
  final Function(PrinterInfo) selectPrinter;

  const _PrinterItemWidget(
    this.printerInfo, {
    required this.selectPrinter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(printerInfo.name)),
        TextButton(
          onPressed: () {
            selectPrinter(printerInfo);
            Scaffold.of(context).closeEndDrawer();
            // Fluttertoast.showToast(msg: printerInfo.name);
          },
          child: const Text('点击使用'),
        ),
      ],
    );
  }
}
