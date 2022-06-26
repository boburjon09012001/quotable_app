import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotable/view_model/bloc/quote_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    _fetchRandom();
  }

  void _fetchRandom() {
    context.read<QuoteBloc>().add(GetRandom());
  }

  int _getRandomNumber(){
    var rng = Random();
    for(var i = 0 ; i < 100 ; i++){
      return rng.nextInt(100);
    }
    return 500;
  }


  NetworkImage _getNewImage(){
    return NetworkImage("https://picsum.photos/200/300/?image=${_getRandomNumber()}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 100,
            controller: PageController(
              initialPage: 0,
              keepPage: true,
              viewportFraction: 1,
            ),
            itemBuilder: (BuildContext context, int index){
              return _buildBlocWidget() ;
            },
            onPageChanged: (index){
              _fetchRandom();
      },
        )
      ),
    );
  }

  Widget buildMain(state){
    return Expanded(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity((0.9)), BlendMode.colorDodge),
              image: _getNewImage(),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.quote.content!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, height: 1.5,
                    color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                ),
              ),
            ),
            IconButton(
              onPressed: _fetchRandom,
              icon: const Icon(
                Icons.refresh,
                size: 48,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildBlocWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<QuoteBloc, QuoteState>(builder: (context, state) {
          if (state is QuoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuoteError) {
            return Center(child: Text(state.message));
          }
          if (state is QuoteSuccess) {
            return  buildMain(state);
          } else {
            return Container();
          }
        }),
      ],
    );

  }
}

