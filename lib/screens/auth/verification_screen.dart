import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();
  final _f4 = FocusNode();

  // Colors: header (bright pink) vs accents (purple-ish)
  static const Color headerPink = Color(0xFFF82A87); // used for title/subtitle
  static const Color accentPink = Color(0xFFC42AF8); // used for borders, buttons, accents

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    _f1.dispose();
    _f2.dispose();
    _f3.dispose();
    _f4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keep default resizeToAvoidBottomInset behavior as needed (changeable)
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC0CB), // light pink
              Color(0xFFADD8E6), // light blue
              Color(0xFFE6E6FA), // lavender
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content (not scrollable — small enough)
              Column(
                children: [
                  const SizedBox(height: 40),

                  // Title (bright pink)
                  const Text(
                    "VERIFY EMAIL",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Color(0xFFF82A87), // headerPink
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle (bright pink header color)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          "ENTER 4 DIGIT OTP CODE SENT TO YOUR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xFFF82A87), // headerPink
                          ),
                        ),
                        Text(
                          "EMAIL ABC@XYX.COM",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black, // headerPink
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // OTP fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _otpBox(_c1, _f1, nextFocus: _f2),
                      const SizedBox(width: 12),
                      _otpBox(_c2, _f2, prevFocus: _f1, nextFocus: _f3),
                      const SizedBox(width: 12),
                      _otpBox(_c3, _f3, prevFocus: _f2, nextFocus: _f4),
                      const SizedBox(width: 12),
                      _otpBox(_c4, _f4, prevFocus: _f3),
                    ],
                  ),
                ],
              ),

              // Bottom area: Submit button and Resend text (fixed)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Column(
                  children: [
                    // Submit (full width with horizontal padding)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPink,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final otp = _c1.text + _c2.text + _c3.text + _c4.text;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("OTP Entered: $otp")),
                          );
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Resend row — accent (purple) for the RESEND text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "DIDN’T RECEIVE A CODE?",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "RESEND",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: accentPink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // OTP box with auto-advance and backspace handling.
  Widget _otpBox(
      TextEditingController controller,
      FocusNode focusNode, {
        FocusNode? nextFocus,
        FocusNode? prevFocus,
      }) {
    // For listening to backspace we use a RawKeyboardListener (works reliably on physical keyboards,
    // and on Android/iOS some keyboards will still generate key events).
    return SizedBox(
      width: 60,
      child: RawKeyboardListener(
        focusNode: FocusNode(), // dedicated listener node
        onKey: (event) {
          // only act on key down events
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty &&
              prevFocus != null) {
            FocusScope.of(context).requestFocus(prevFocus);
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: accentPink, width: 1.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: accentPink, width: 1.8),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              // when user types, move forward
              if (nextFocus != null) {
                FocusScope.of(context).requestFocus(nextFocus);
              } else {
                focusNode.unfocus();
              }
            }
            // if user cleared the current field (value == ""), we do NOT automatically move back here.
            // Backspace handling is done through RawKeyboardListener above.
          },
          onTap: () {
            // place cursor at end if user re-enters the field
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          },
        ),
      ),
    );
  }
}
