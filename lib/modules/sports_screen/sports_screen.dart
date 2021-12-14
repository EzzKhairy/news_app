import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:news_app/components/components.dart';
import 'package:news_app/cubit/cubit.dart';
import 'package:news_app/cubit/states.dart';

class SportsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).sports;

        return Conditional.single(
          context: context,
          conditionBuilder: (context) => list.isNotEmpty,
          widgetBuilder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildArticleItem(list[index], context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Divider(color: Colors.grey,),
            ),
            itemCount: list.length,
          ),
          fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}