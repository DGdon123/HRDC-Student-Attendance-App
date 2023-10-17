// ignore_for_file: public_member_api_docs, sort_constructors_first
class Population {
  final List<PopulationModel> populationList;
  Population({
    required this.populationList,
  });
}

class PopulationModel {
  final String males;
  final String females;
  final String other;
  final String total;
  bool value;
  bool find;
  PopulationModel({
    required this.males,
    required this.females,
    required this.other,
    required this.total,
    this.value = false,
    this.find = false,
  });
}
