import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/modules/business_screen/business_screen.dart';
import 'package:news_app/modules/science_screen/science_screen.dart';
import 'package:news_app/modules/sports_screen/sports_screen.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
          Icons.business,
        ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Icons.sports,
        ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Icons.science,
        ),
      label: 'Science',
    ),
  ];

  List<Widget> screens =[
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 1) {
      getSports();
    }
    else if(index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  void getBusiness() {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
      url: 'v2/top-headlines' ,
      query: {
        'country' : 'eg',
        'category' : 'business',
        'apiKey' : '2390ddcfe65c4fa0a94a11d620863fc8',
      },
    ).then((value)
    {
      // print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];
  void getSports() {
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '2390ddcfe65c4fa0a94a11d620863fc8',
        },
      ).then((value) {
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else
      {
        emit(NewsGetSportsSuccessState());
      }
  }

  List<dynamic> science = [];
  void getScience() {
    emit(NewsGetScienceLoadingState());

    if(science.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science_screen',
          'apiKey': '2390ddcfe65c4fa0a94a11d620863fc8',
        },
      ).then((value) {
        science = value.data['articles'];
        print(science[0]['title']);

        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else
      {
        emit(NewsGetScienceSuccessState());
      }
  }


  List<dynamic> search = [];
  void getSearch(String value) {
    emit(NewsGetScienceLoadingState());
    search = [];
    {
      DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': value,
          'apiKey': '2390ddcfe65c4fa0a94a11d620863fc8',
        },
      ).then((value) {
        search = value.data['articles'];
        print(search[0]['title']);

        emit(NewsGetSearchSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSearchErrorState(error.toString()));
      });
    }
  }


  ThemeMode appMode = ThemeMode.light;
  bool isDark = false;
  void changeAppThemeMode({bool ?fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(ChangeAppThemeModeState());
    }
    else {
      isDark =! isDark;
    }
    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
    {
      if(isDark)
      {
        appMode = ThemeMode.dark;
      }
      else
      {
        appMode = ThemeMode.light;
      }
      emit(ChangeAppThemeModeState());
    });
  }
}