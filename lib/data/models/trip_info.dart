class TripInfo{
  bool? flag;
  String? startStationName;
  String? endStationName;
  String? beginTime;
  String? endTime;

  TripInfo({required this.flag, required this.startStationName, required this.beginTime, required this.endStationName , required this.endTime});

TripInfo.fromJson(Map trip){
  flag=trip['flag'];
  startStationName=trip['begin station Name'];
  beginTime=trip['begin trip'];
  endStationName=trip['end station Name'];
  endTime=trip['end trip'];
}
}