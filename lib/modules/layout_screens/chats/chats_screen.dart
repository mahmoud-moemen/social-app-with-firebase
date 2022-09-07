import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/layout_screens/chats/chat_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/social_layout/layoutCubit/layout_states.dart';

import '../../../social_layout/layoutCubit/layout_cubit.dart';

class ChatsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition:LayoutCubit.get(context).users.isNotEmpty ,
          builder: (context)=>ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index)=>buildChatItem(LayoutCubit.get(context).users[index],context),
              separatorBuilder: (context,index)=>Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: LayoutCubit.get(context).users.length),
          fallback:(context)=>Center(child: CircularProgressIndicator()) ,
        );
      },

    );
  }


  Widget buildChatItem(UserModel model,context)=>  InkWell(
    onTap: ()
    {
      navigateTo(context, ChatDetailsScreen(userModel: model));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
                '${model.image}'
            ),
          ),
          SizedBox(width: 15.0,),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
