import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 小票样式 demo， （用于生成图片 - 打印）
class ReceiptStyleWidget extends StatefulWidget {
  final Map dataDic;
  const ReceiptStyleWidget({
    required this.dataDic,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TempReceiptWidgetState();
}

class _TempReceiptWidgetState extends State<ReceiptStyleWidget> {
  @override
  Widget build(BuildContext context) {
    return _homeBody();
  }

  Widget _homeBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.dataDic["pick_code"],
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                ),
              ),
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "自提时间：",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                widget.dataDic['pick_time'],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "姓名：",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                widget.dataDic["username"],
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "电话：",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                widget.dataDic["mobile"],
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            children: [
              Text(
                "商品",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              Spacer(),
              Text(
                "数量",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          const SizedBox(height: 12,),
          ...widget.dataDic["product"].map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          ...item['specifications'].map((item2) {
                            return Text(
                              item2+'，',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            );
                          }).toList()
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        item['num'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
