import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honorfx/cubit/signup/signup_cubit.dart';
import 'package:honorfx/cubit/signup/signup_state.dart';
import 'package:honorfx/models/country_model.dart';
import 'package:honorfx/models/signup_model.dart';
import 'package:honorfx/screens/login/login_screen.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:honorfx/utils/countries.dart';
import 'package:honorfx/widgets/country_dropdown.dart';
import 'package:honorfx/widgets/gradient_background.dart';
import 'package:honorfx/widgets/loading/loading.dart';
import 'package:honorfx/widgets/textfields/email_text_field.dart';
import 'package:honorfx/widgets/textfields/phone_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  CountryModel? _selectedCountry;
  final List<CountryModel> _countries = Countries.getCountries();
  final _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set default country initially, will be replaced with device country
    _selectedCountry = Countries.getDefaultCountry();
    // Get device country
    _loadDeviceCountry();
  }

  // Load device country asynchronously
  Future<void> _loadDeviceCountry() async {
    try {
      final CountryModel deviceCountry = await Countries.getDeviceCountry();
      if (mounted) {
        setState(() {
          _selectedCountry = deviceCountry;
        });
      }
    } catch (e) {
      // Fallback to default country already set in initState
      debugPrint('Error loading device country: $e');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _referralCodeController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          child: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state is SignupLoading) {
                // Show loading indicator if needed
              } else if (state is SignupSuccess) {
                Fluttertoast.showToast(
                  msg: "Signup successful!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );

                // Navigate to login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (state is SignupError) {
                Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          // Logo
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/honorfx_logo.svg',
                              height: 60.h,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          // Welcome text
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.lightGrey,
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // Full Name input
                          _buildInputLabel('Full Name'),
                          SizedBox(height: 8.h),
                          CommanTexfield(
                            hintText: 'Enter your full name',
                            controller: _fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Email input
                          _buildInputLabel('Email'),
                          SizedBox(height: 8.h),
                          EmailTextField(controller: _emailController),
                          SizedBox(height: 16.h),

                          // Country input
                          _buildInputLabel('Country'),
                          SizedBox(height: 8.h),
                          CountryDropdown(
                            countries: _countries,
                            selectedCountry: _selectedCountry,
                            hintText: 'Select your country',
                            onChanged: (CountryModel? country) {
                              setState(() {
                                _selectedCountry = country;
                                // Focus on the phone field after selecting country
                                if (country != null) {
                                  _phoneFocusNode.requestFocus();
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a country';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Phone input
                          _buildInputLabel('Phone'),
                          SizedBox(height: 8.h),
                          PhoneTextField(
                            controller: _phoneController,
                            selectedCountry: _selectedCountry,
                            focusNode: _phoneFocusNode,
                          ),
                          SizedBox(height: 16.h),

                          // Password input
                          _buildInputLabel('Password'),
                          SizedBox(height: 8.h),
                          _buildPasswordField(
                            isVisible: _isPasswordVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            hintText: 'Create password',
                            controller: _passwordController,
                          ),
                          SizedBox(height: 16.h),

                          // Referral Code input
                          _buildInputLabel('Referral Code'),
                          SizedBox(height: 8.h),
                          CommanTexfield(
                            hintText: 'Enter your referral code',
                            controller: _referralCodeController,
                          ),
                          SizedBox(height: 20.h),

                          // Terms and conditions checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value!;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            'By creating an account, you agree to our ',
                                      ),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          // Signup Button
                          _buildSignupButton(state),
                          SizedBox(height: 30.h),

                          // Already have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                  if (state is SignupLoading) const Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildPasswordField({
    required bool isVisible,
    required Function onToggleVisibility,
    required String hintText,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: () => onToggleVisibility(),
        ),
      ),
    );
  }

  Widget _buildSignupButton(SignupState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!_agreeToTerms) {
            Fluttertoast.showToast(
              msg: "Please agree to terms and conditions",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            return;
          }

          if (!_formKey.currentState!.validate()) {
            Fluttertoast.showToast(
              msg: "Please fill all required fields",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            return;
          }

          context.read<SignupCubit>().signup(
            signupModel: SignupModel(
              name: _fullNameController.text,
              email: _emailController.text,
              country: _selectedCountry!.code,
              password: _passwordController.text,
              mobile: _phoneController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: SvgPicture.asset(
                'assets/icons/arrow-circle-right.svg',
                width: 20.w,
                height: 20.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
