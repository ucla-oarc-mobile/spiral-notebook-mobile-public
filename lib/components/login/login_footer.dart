import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 89.0,
            child: Image.asset(
              'images/logo/logo-nsf.png',
              semanticLabel: "National Science Foundation",
            ),
          ),
          SizedBox(height: 22.0),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: viewportConstraints.maxWidth,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40.0,
                        child: Image.asset(
                          'images/logo/logo-ucla.png',
                          semanticLabel: "UCLA",
                        )
                      ),
                      Container(
                        height: 40.0, child: Image.asset(
                          'images/logo/logo-nd.png',
                          semanticLabel: "University of Notre Dame",
                        )
                      ),
                    ],
                  ),
                );
            }
          ),
        ],
      ),
    );
  }
}
