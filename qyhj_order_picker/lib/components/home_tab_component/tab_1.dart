
//待取货
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tab1 extends StatelessWidget {
  final Function(int) checkTap;

  List<dynamic> data;

  Tab1(
      {super.key,
      required this.data,
      required this.checkTap});

  

  void _handleCheck(index) {
    checkTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 12,
                  )
                ]),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            margin: const EdgeInsets.only(bottom: 12, top: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 155,
                  height: 155,
                  child: Center(
                    child: Text(
                      data[index]["pick_code"],
                      style:
                          const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      data[index]['out_trade_no'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 405,
                      color: Colors.white,
                      child: Text(
                        "客户姓名：${data[index]['username']}",
                        style:const TextStyle(fontSize: 18, color: Colors.grey),
                        maxLines: 5,
                        softWrap: true,
                      ),
                    ),
                    
                     Text(
                      "客户电话：${data[index]['mobile']}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                     Text(
                      "下单时间：${data[index]['order_time']}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    
                    IconButton(
                      onPressed: () {
                        _handleCheck(index);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 40,
                        color: Colors.blue,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
