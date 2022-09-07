import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import '../../shared/components/components.dart';
import '../../social_layout/socail_layout.dart';

class LoginScreen  extends StatelessWidget {

 var formKey = GlobalKey<FormState>();
 var emailController = TextEditingController();
 var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state)
        {
          if(state is LoginErrorState)
          {
            showToast(text: state.error, state: toastStates.ERROR);
          }
          if(state is LoginSuccessState)
          {
            CacheHelper.saveData(key: 'uId', value: state.uId)
                .then((value)
            {
              navigateAndFinish(context, SocailLayout());
            })
                .catchError((error)
            {

            });
          }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start ,
                      children:
                      [
                        Text(
                          'LOGIN',
                          style:Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black
                          ),
                        ),
                        Text(
                          'Login Now To Communicate With Friends',
                          style:Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'please enter your email address';
                              }
                              return null;

                            },
                            label: 'Email Address',
                            prefix:Icons.email_outlined),
                        SizedBox(height: 20.0,),
                        defaultFormField(
                            controller: passwordController,
                            onSubmitted: (value)
                            {
                              if (formKey.currentState != null && formKey.currentState!.validate())
                              {

                                // LoginCubit.get(context).userLogin(
                                // email: emailController.text,
                                // password:passwordController.text );
                              }
                            },
                            type: TextInputType.visiblePassword,
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'please enter your password';
                              }
                              return null;


                            },
                            label: 'Password',
                            prefix:Icons.lock_clock_outlined,
                            isPassword:LoginCubit.get(context).isPassword,
                            suffix:LoginCubit.get(context).suffix ,
                            suffixPressed: ()
                            {
                              LoginCubit.get(context).changePasswordVisibility();
                            }),
                        SizedBox(height: 30.0),
                        ConditionalBuilder(
                          condition:state is! LoginLoadingState ,
                          builder:(context)=>defaultButton(
                              callback: ()
                              {
                                if (formKey.currentState != null && formKey.currentState!.validate())
                                {

                                  LoginCubit.get(context).userLogin
                                    (
                                      email: emailController.text,
                                      password:passwordController.text );
                                }

                              },
                              text:'login'  ) ,
                          fallback:(context)=> Center(child: CircularProgressIndicator()),

                        ),
                        SizedBox(height: 15.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text(
                              'Don\'t have an account',
                            ),
                            defaultTextButton(callback:
                                ()
                            {
                              navigateTo(context, RegisterScreen());
                            }
                                , text: 'register'),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,

      ),
    );
  }
}
