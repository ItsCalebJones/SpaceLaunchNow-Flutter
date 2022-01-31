import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class StarshipVehiclePage extends StatefulWidget {
  const StarshipVehiclePage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _StarshipVehiclePageState createState() => _StarshipVehiclePageState();
}

class _StarshipVehiclePageState extends State<StarshipVehiclePage> {
  Starship? _starship;
  bool loading = false;
  bool usingCached = false;
  final SLNRepository _repository = Injector().slnRepository;
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    Starship? starship =
        PageStorage.of(context)!.readState(context, identifier: 'starship');
    if (starship != null) {
      _starship = starship;
      usingCached = true;
    } else {
      lockedLoadNext();
    }
    isSelected = [true, false];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLoadResponseComplete(Starship starship, [bool reload = false]) {
    loading = false;
    usingCached = false;

    setState(() {
      _starship = starship;
      PageStorage.of(context)!
          .writeState(context, _starship, identifier: 'starship');
    });
  }

  void onLoadContactsError([bool? search]) {
    print("An error occured!");
    setState(() {
      loading = false;
    });
  }

  ThemeData get appBarTheme {
    if (widget._configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return kIOSTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Widget> content = <Widget>[];
    if (_starship == null || loading) {
      content.add(SizedBox(height: 200));
      content.add(Center(
        child: CircularProgressIndicator(),
      ));
    } else if (_starship == null) {
      content.add(const SizedBox(height: 200));
      content.add(Center(
        child: const Text("Unable to Load Dashboard"),
      ));
    } else {
      content.addAll(_buildList());
      content.add(const SizedBox(
        height: 50,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: content,
          ),
        ),
      ],
    );
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext(force: true);
    }
  }

  void loadNext({bool? force}) {
    loading = true;
    if ((!usingCached) || force!) {
      _repository
          .fetchStarshipDashboard()
          .then((response) => onLoadResponseComplete(response))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  List<Widget> _buildList() {
    List<Widget> content = <Widget>[];

    for (Object item in _starship!.launchers!) {
      content.add(_buildVehicleTile(item as Launcher));
    }
    return content;
  }

  Widget _buildVehicleTile(Launcher item) {
    var formatter = DateFormat.yMd();
    String? imgUrl;
    if (item.image != null) {
      imgUrl = item.image;
    } else {
      imgUrl =
          "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(imgUrl!),
        ),
        title: Text(
            item.launcherConfiguration!.name! + " | " + item.serialNumber!,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(item.details!),
        trailing: Text(
            '${item.status![0].toUpperCase()}${item.status!.substring(1)}',
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }
}
