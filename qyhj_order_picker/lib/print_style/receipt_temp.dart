import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_generate_widget.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import '../../module/printer_info.dart';
import 'container_box/receipt_constrained_box.dart';
import 'demo/receipt_temp_demo.dart';

//预览小票
class ReceiptTempWidget extends BaseGenerateWidget {
  final PrinterInfo printerInfo;
  final int receiptWidth;
  final Map dataDic;
  const ReceiptTempWidget(
    this.printerInfo, {
    Key? key,
    required this.dataDic,
    required this.receiptWidth,
  }) : super(key: key);

  @override
  void doPrint() {
    debugPrint("打印设备信息===>>${printerInfo.name}");
    // 生成打印图层任务，指定任务类型为小票
    PictureGeneratorProvider.instance.addPicGeneratorTask(
      PicGenerateTask<PrinterInfo>(
        tempWidget: child() as ATempWidget,
        printTypeEnum: PrintTypeEnum.receipt,
        params: printerInfo,
      ),
    );
  }

  @override
  Widget child() {
    debugPrint("Widget child()");
    return  ReceiptConstrainedBox(
      ReceiptStyleWidget(dataDic: dataDic),
      pageWidth: receiptWidth,
    );
  }
}
