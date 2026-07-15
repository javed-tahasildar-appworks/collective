import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CollectionInput extends StatefulWidget {
  static String routeName = "/modules/collect-screen-module/collection_input";

  const CollectionInput({super.key});

  @override
  State<CollectionInput> createState() => _CollectionInputState();
}

class _CollectionInputState extends State<CollectionInput> {
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod('Cash', Icons.payments_outlined, const Color(0xFF6366F1)),
    PaymentMethod(
        'UPI', Icons.account_balance_wallet_outlined, const Color(0xFF10B981)),
    PaymentMethod('Card', Icons.credit_card_outlined, const Color(0xFFF59E0B)),
  ];

  late PaymentMethod _selectedMethod;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMethod = _paymentMethods.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildCustomerCard(),
                    const SizedBox(height: 40),
                    _buildAmountSection(),
                    const SizedBox(height: 24),
                    _buildNoteSection(),
                    const Spacer(),
                    _buildNumericKeypad(),
                    const SizedBox(height: 24),
                    _buildReceiveButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 24, top: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xFF1F2937)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Collection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'JM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Jamna Mobiles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '#1234567890',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPaymentMethodSelector(),
          const SizedBox(width: 12),
          Expanded(child: _buildAmountInput()),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMethod>(
          value: _selectedMethod,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF64748B)),
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          onChanged: (PaymentMethod? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedMethod = newValue;
              });
            }
          },
          items: _paymentMethods
              .map<DropdownMenuItem<PaymentMethod>>((PaymentMethod method) {
            return DropdownMenuItem<PaymentMethod>(
              value: method,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: method.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      method.icon,
                      size: 16,
                      color: method.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    method.name,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      readOnly: true,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: Text(
            '₹',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        hintText: '0.00',
        hintStyle: TextStyle(
          color: const Color(0xFF9CA3AF).withOpacity(0.6),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildNoteSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _noteController,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF374151),
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
          ),
          hintText: 'Add a note (optional)',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 12),
        _buildKeypadRow(['.', '0', '⌫']),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKeypadButton(key)).toList(),
    );
  }

  Widget _buildKeypadButton(String key) {
    final isBackspace = key == '⌫';
    final isDot = key == '.';

    return GestureDetector(
      onTap: () => _handleKeypadTap(key),
      child: Container(
        width: 72,
        height: 56,
        decoration: BoxDecoration(
          color: isBackspace ? const Color(0xFFF3F4F6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isBackspace
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xFF6B7280),
                  size: 20,
                )
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: isDot ? 24 : 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildReceiveButton() {
    final hasAmount =
        _amountController.text.isNotEmpty && _amountController.text != '0';

    return GestureDetector(
      onTap: hasAmount ? () => _showReceiveBottomSheet() : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: hasAmount
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: hasAmount ? null : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: hasAmount
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Receive Payment',
            style: TextStyle(
              color: hasAmount ? Colors.white : const Color(0xFF9CA3AF),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _handleKeypadTap(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amountController.text.isNotEmpty) {
          _amountController.text = _amountController.text.substring(
            0,
            _amountController.text.length - 1,
          );
        }
      } else if (key == '.') {
        if (!_amountController.text.contains('.')) {
          _amountController.text += key;
        }
      } else {
        // Prevent multiple leading zeros
        if (_amountController.text == '0' && key != '.') {
          _amountController.text = key;
        } else {
          _amountController.text += key;
        }
      }
    });
  }

  void _showReceiveBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              'Scan QR to Pay',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Amount: ₹${_amountController.text}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 40),

            // QR Code
            Container(
              width: 220,
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildQRCodePlaceholder(),
            ),

            const SizedBox(height: 40),

            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              height: 1,
              color: const Color(0xFFE5E7EB),
            ),

            const SizedBox(height: 32),

            // UPI ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'jamnamobiles@okbank',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jamna Mobiles Pvt. Ltd.',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF6B7280).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          const ClipboardData(text: 'jamnamobiles@okbank'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('UPI ID copied to clipboard'),
                          backgroundColor: Color(0xFF6366F1),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: Color(0xFF6B7280),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Received button
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to receipt screen
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Payment Received',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Stack(
        children: [
          // QR pattern simulation
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
              childAspectRatio: 1,
            ),
            itemCount: 144,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: (index % 3 == 0 || index % 7 == 0 || index % 11 == 0)
                      ? const Color(0xFF1F2937)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          ),
          // Center UPI logo
          Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'UPI',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod {
  final String name;
  final IconData icon;
  final Color color;

  PaymentMethod(this.name, this.icon, this.color);
}

// import 'dart:developer';

// import 'package:collectiv/modules/collect-screen-module/ui/payment_receipt_screen.dart';
// import 'package:collectiv/utils/app_extensions.dart';
// import 'package:collectiv/utils/app_widgets.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:collectiv/utils/string_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CollectionInput extends StatelessWidget {
//   static String routeName = "/modules/collect-screen-module/collection_input";
//   final List<String> _paymentMethods = [cash, upi];
//   late final String _selectedMethod;

//   CollectionInput({super.key}) {
//     _selectedMethod = _paymentMethods.first;
//   }
//   final TextEditingController _amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         backgroundColor: kWhite,
//         title: Text(
//           "Jamna Mobiles",
//           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_rounded),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // User info
//             Column(
//               children: [
//                 // Avatar
//                 Container(
//                   width: getProportionateWidth(64.0),
//                   height: getProportionateHeight(64.0),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[200],
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'JM',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Name and verified icon
//                 Text(
//                   'Jamna Mobiles',
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: getProportionateHeight(8.0)),

//                 // Customer Id
//                 Text(
//                   '#1234567890',
//                   style: TextStyle(
//                     color: trend,
//                     fontSize: 12.sp,
//                   ),
//                 ),

//                 const SizedBox(height: 16),
//               ],
//             ),

//             const Spacer(),

//             // Payment input section
//             Column(
//               children: [
//                 _paymentView(),
//                 const SizedBox(height: 16),

//                 // Add note button
//                 textField(
//                     onChanged: (String value) {
//                       // Handle the input value here
//                     },
//                     hint: addNote,
//                     hintStyle: TextStyle(
//                       color: trendLight,
//                       fontSize: 14.sp,
//                     ),
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: trend,
//                     ),
//                     inputType: TextInputType.text,
//                     maxLines: 2,
//                     minLines: 1,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: const BorderSide(color: trend),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: const BorderSide(color: trend),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: const BorderSide(color: trend),
//                     ),
//                     prefix: IconButton(
//                         onPressed: () => log("Take Note..."),
//                         icon: const Icon(Icons.speaker_notes)),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'[a-zA-Z0-9!@#\$%^&*()_+-= ]')),
//                     ]).withPadding(EdgeInsets.symmetric(
//                     horizontal: getProportionateWidth(16.0)))
//               ],
//             ),

//             const Spacer(),

//             // Numeric keypad
//             _buildNumberPad(),

//             SizedBox(height: getProportionateHeight(16.0)),

//             // Payment controls
//             Container(
//               width: double.infinity,
//               padding:
//                   EdgeInsets.symmetric(vertical: getProportionateHeight(14.0)),
//               decoration: BoxDecoration(
//                 color: trendDark,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Center(
//                 child: Text(
//                   receiveNow,
//                   style: TextStyle(
//                     color: kWhite,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             )
//                 .withPadding(
//                   EdgeInsets.symmetric(
//                     horizontal: getProportionateWidth(16.0),
//                     vertical: getProportionateHeight(16.0),
//                   ),
//                 )
//                 .onClick(
//                   onClick: () {
//                     // Handle the payment action here
//                     _showReceiveBottomSheet(context);
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   splashColor: Colors.white.withOpacity(0.1),
//                 )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _paymentView() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
//       decoration: BoxDecoration(
//         color: kWhite,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: trend),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Payment method dropdown in a circle
//           Container(
//             height: 48.sp,
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: kWhite,
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 dropdownColor: kWhite,
//                 value: _selectedMethod,
//                 icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                 elevation: 0,
//                 isDense: true,
//                 alignment: Alignment.center,
//                 borderRadius: BorderRadius.circular(16),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 onChanged: (String? newValue) {},
//                 items: _paymentMethods
//                     .map<DropdownMenuItem<String>>((String value) {
//                   IconData icon;
//                   switch (value) {
//                     case 'Cash':
//                       icon = Icons.money;
//                       break;
//                     case 'UPI':
//                       icon = Icons.account_balance_wallet_outlined;
//                       break;
//                     case 'Card':
//                       icon = Icons.credit_card;
//                       break;
//                     default:
//                       icon = Icons.payment;
//                   }

//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(icon, size: 18, color: trend),
//                         const SizedBox(width: 8),
//                         Text(
//                           value,
//                           style: const TextStyle(
//                             color: trend,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),

//           SizedBox(width: getProportionateWidth(16.0)),

//           Expanded(
//             child: TextFormField(
//               controller: _amountController,
//               keyboardType: TextInputType.none,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//               ],
//               decoration: InputDecoration(
//                 prefixIcon: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                   child: Text(
//                     '₹',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.blueGrey.shade700,
//                     ),
//                   ),
//                 ),
//                 hintText: 'Amount',
//                 hintStyle: TextStyle(
//                   color: trendLight,
//                   fontSize: 16.sp,
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: const BorderSide(color: kWhite),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: const BorderSide(color: kWhite),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: const BorderSide(color: kWhite, width: 1.5),
//                 ),
//                 filled: true,
//                 fillColor: kWhite,
//               ),
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: trend,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberPad() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: getProportionateWidth(16.0)),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildKeypadButton('1'),
//               _buildKeypadButton('2'),
//               _buildKeypadButton('3'),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildKeypadButton('4'),
//               _buildKeypadButton('5'),
//               _buildKeypadButton('6'),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildKeypadButton('7'),
//               _buildKeypadButton('8'),
//               _buildKeypadButton('9'),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildKeypadButton('.', isSpecial: true),
//               _buildKeypadButton('0'),
//               _buildKeypadButton('⌫', isSpecial: true, onTap: () {
//                 if (_amountController.text.isNotEmpty) {
//                   _amountController.text = _amountController.text
//                       .substring(0, _amountController.text.length - 1);
//                 }
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildKeypadButton(String text,
//       {bool isSpecial = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap ??
//           () {
//             if (text == '.' && _amountController.text.contains('.')) return;
//             _amountController.text += text;
//           },
//       child: Container(
//         width: getProportionateWidth(120.0),
//         height: getProportionateHeight(64.0),
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(30),
//           color: isSpecial ? trend : trendDark,
//           border: Border.all(
//             color: kWhite,
//             width: 1,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.normal,
//               color: kWhite,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// // Then add this method to your CollectionInput class:
//   // Modify your existing code by updating the "Receive Now" button with this implementation
//   void _showReceiveBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         decoration: const BoxDecoration(
//           color: kWhite,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Bottom sheet handle
//             Container(
//               margin: EdgeInsets.only(top: getProportionateHeight(12.0)),
//               width: getProportionateWidth(40.0),
//               height: getProportionateHeight(4.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),

//             SizedBox(height: getProportionateHeight(24.0)),

//             // Title and subtitle
//             Text(
//               receiveAmount,
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 color: trendDark,
//               ),
//             ),

//             SizedBox(height: getProportionateHeight(4.0)),

//             Text(
//               fromAnyUPIApp,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: trendLight,
//               ),
//             ),

//             SizedBox(height: getProportionateHeight(32.0)),

//             // QR Code
//             Container(
//               width: getProportionateWidth(220.0),
//               height: getProportionateWidth(220.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade100,
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   )
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   // Placeholder for QR code - in real app replace with QR code widget
//                   child: Container(
//                     width: getProportionateWidth(200.0),
//                     height: getProportionateWidth(200.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: Stack(
//                       children: [
//                         // This represents the QR code pattern
//                         // In actual implementation, you'd use a QR code generator
//                         GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 10,
//                             childAspectRatio: 1,
//                           ),
//                           itemCount: 100,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return Container(
//                               margin: const EdgeInsets.all(1),
//                               color: (index % 3 == 0 || index % 7 == 0)
//                                   ? Colors.black
//                                   : Colors.white,
//                             );
//                           },
//                         ),
//                         // Center logo overlay
//                         Center(
//                           child: Container(
//                             width: getProportionateWidth(40.0),
//                             height: getProportionateWidth(40.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: trendDark, width: 2),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'UPI',
//                                 style: TextStyle(
//                                   color: trendDark,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: getProportionateHeight(32.0)),

//             // Divider
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: getProportionateWidth(24.0)),
//               child: Divider(color: Colors.grey.shade300, thickness: 1),
//             ),

//             SizedBox(height: getProportionateHeight(24.0)),

//             // UPI ID with copy icon
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: getProportionateWidth(24.0)),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "jamnamobiles@okbank",
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w500,
//                             color: trendDark,
//                           ),
//                         ),
//                         SizedBox(height: getProportionateHeight(4.0)),
//                         Text(
//                           "Jamna Mobiles Pvt. Ltd.",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: trendLight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.copy_rounded,
//                       color: trendDark,
//                       size: 20.sp,
//                     ),
//                   ).onClick(
//                     onClick: () {
//                       // Implement copy functionality
//                       Clipboard.setData(
//                           const ClipboardData(text: "jamnamobiles@okbank"));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("UPI ID copied to clipboard"),
//                           backgroundColor: trendDark,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     },
//                     borderRadius: BorderRadius.circular(8),
//                     splashColor: Colors.white.withOpacity(0.1),
//                   ),
//                 ],
//               ),
//             ),

//             const Spacer(),

//             // Close button at the bottom
//             Container(
//               width: double.infinity,
//               padding:
//                   EdgeInsets.symmetric(vertical: getProportionateHeight(14.0)),
//               decoration: BoxDecoration(
//                 color: trendDark,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Center(
//                 child: Text(
//                   received,
//                   style: TextStyle(
//                     color: kWhite,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             )
//                 .withMargin(
//                   EdgeInsets.symmetric(
//                     horizontal: getProportionateWidth(16.0),
//                     vertical: getProportionateHeight(16.0),
//                   ),
//                 )
//                 .onClick(
//                   onClick: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(
//                         context, PaymentReceiptScreen.routeName);
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   splashColor: Colors.white.withOpacity(0.1),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
