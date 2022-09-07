import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/social_layout/layoutCubit/layout_cubit.dart';

import '../../../models/user_model.dart';
import '../../../social_layout/layoutCubit/layout_states.dart';

class ChatDetailsScreen extends StatelessWidget
{
  UserModel userModel;
  ChatDetailsScreen({required this.userModel});

  var messageController= TextEditingController();
  @override
  Widget build(BuildContext context)
  {

    return Builder(
      builder: (context)
      {
        LayoutCubit.get(context).getMessages(receiverId: userModel.uId!);

        return BlocConsumer<LayoutCubit , LayoutStates>(
          listener: (context,state){},

          builder: (context,state)
          {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${userModel.image}',
                      ),

                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${userModel.name}',
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: LayoutCubit.get(context).messages.isNotEmpty,
                builder:(context)=>  Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children:
                    [
                      // buildMessage(),
                      // buildMyMessage(),
                      // Spacer(),
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index)
                            {
                              var message=LayoutCubit.get(context).messages[index];
                              if(LayoutCubit.get(context).userModel!.uId == message.senderId )
                                return buildMyMessage(message);

                              return buildMessage(message);
                            },
                            separatorBuilder: (context, index)=>SizedBox(
                              height: 15.0,
                            ),
                            itemCount: LayoutCubit.get(context).messages.length),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children:
                          [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message ...',

                                ),
                              ),
                            ),
                            Container(
                              //height: 40.0,
                              color: defaultColor,
                              child: MaterialButton(
                                onPressed: ()
                                {
                                  LayoutCubit.get(context).sendMessage(
                                      receiverId: userModel.uId!,
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text);
                                },
                                minWidth: 1.0,

                                child: Icon(
                                  IconBroken.Send,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback:(context)=>Center(child: const CircularProgressIndicator()) ,

              ),
            );
          },

        );
      }
    );
  }


  Widget buildMessage(MessageModel model)=>Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          topStart:Radius.circular(10.0),
          topEnd:Radius.circular(10.0) ,
          bottomEnd:Radius.circular(10.0) ,


        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0
      ),
      child: Text(
        '${model.text}',
      ),
    ),
  );


  Widget buildMyMessage(MessageModel model)=>Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(0.2),
        borderRadius: BorderRadiusDirectional.only(
          topStart:Radius.circular(10.0),
          topEnd:Radius.circular(10.0) ,
          bottomStart:Radius.circular(10.0) ,


        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0
      ),
      child: Text(
        model.text!,
      ),
    ),
  );

}
