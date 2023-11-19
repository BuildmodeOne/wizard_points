import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wizard_points/shared/appbar.dart';

class CustomLicensePage extends StatelessWidget {
  const CustomLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar(context, 'Licenses'),
      body: FutureBuilder(
        future: getLicenses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var licenses = snapshot.data as Map<String, List<String>>;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: licenses.length,
              itemBuilder: (context, index) {
                var license = licenses.entries.elementAt(index);

                return Card(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            FluentIcons.document_bullet_list_20_regular,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              license.key,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: license.value.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(license.value[index]),
                                  Visibility(
                                    visible: index != license.value.length - 1,
                                    child: const Divider(),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, List<String>>> getLicenses() async {
    Map<String, List<String>> licenseMap = {};

    await for (var license in LicenseRegistry.licenses) {
      // ignore: avoid_function_literals_in_foreach_calls
      license.packages.forEach((package) {
        var licenses = licenseMap[package] ?? [];
        licenses.add(
            license.paragraphs.map((paragraph) => paragraph.text).join('\n\n'));

        licenseMap[package] = licenses;
      });
    }

    //order map by key
    licenseMap = Map.fromEntries(
        licenseMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    return licenseMap;
  }
}
