import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:client_shared/components/sheet_title_view.dart';

class EnterCouponCodeSheetView extends StatefulWidget {
  const EnterCouponCodeSheetView({Key? key}) : super(key: key);

  @override
  State<EnterCouponCodeSheetView> createState() =>
      _EnterCouponCodeSheetViewState();
}

class _EnterCouponCodeSheetViewState extends State<EnterCouponCodeSheetView> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetTitleView(
              title: "Coupon Code",
              closeAction: () => Navigator.pop(context),
            ),
            Text(
              "Insert your coupon code to be applied on the price",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() {
                code = value;
              }),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.orange.withOpacity(0.2),
                isDense: true,
                prefixIcon: Icon(
                  Ionicons.pricetag,
                  color: Colors.orange,
                ),
                hintText: "Enter coupon code",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    onPressed: code.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context, code);
                          },
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
