import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/social_layout/layoutCubit/layout_cubit.dart';
import 'package:social_app/social_layout/layoutCubit/layout_states.dart';

import '../../shared/components/components.dart';

class NewPostScreen extends StatelessWidget {

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var postImage=LayoutCubit.get(context).postImage;
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
              actions:
              [
                defaultTextButton(callback: ()
                {
                  var now =DateTime.now();

                  if(LayoutCubit.get(context).postImage == null)
                  {
                    LayoutCubit.get(context).createPost(
                        dateTime: now.toString(), text: textController.text);
                  }else
                  {
                    LayoutCubit.get(context).uploadPostImage(
                        dateTime: now.toString(), text: textController.text);
                  }
                }, text:'Post' ),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children:
              [
               if(state is LayoutCreatePostLoadingState)
                 LinearProgressIndicator(),
                if(state is LayoutCreatePostLoadingState)
                  SizedBox(height: 10.0,),
                Row(
                  children:
                  [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage('https://img.freepik.com/free-photo/brunette-woman-doing-winner-gesture-happy-excited-looking-up-with-closed-eyes-white-background_231208-13971.jpg?t=st=1657444321~exp=1657444921~hmac=8786b7b4913926868aeb6d59a35f9494a80e52e911451243170d6349ca82f57d&w=740'),
                    ),
                    SizedBox(width: 15.0,),
                    Expanded
                      (
                      child: Text(
                        'Mahmoud Moamen',
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                if (LayoutCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children:
                    [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image:FileImage(postImage!)as ImageProvider,
                            fit: BoxFit.cover,

                          ),
                        ),
                      ),
                      IconButton(
                          icon:CircleAvatar(

                            radius: 20.0,
                            child: Icon(
                              Icons.close,
                              size: 16.0,
                            ),
                          ) ,
                          onPressed: ()
                          {
                            LayoutCubit.get(context).removePostImage();
                          }),
                    ],
                  ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(onPressed: ()
                      {
                        LayoutCubit.get(context).getPostImage();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Icon(
                            IconBroken.Image,
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            'add photo',
                          ),
                        ],
                      ) ),
                    ),
                    Expanded(
                      child: TextButton(onPressed: (){}, child: Text(
                        '# tags',
                      ), ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
