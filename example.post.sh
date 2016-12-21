curl -XPOST -H "Accept: application/json"  $1 -d '
{
  "_index": "cwl-2016.12.21",
  "_type": "log-groups-testLinuxMessage-IKFZQVD2BNL",
  "_id": "33056800637449772331545945892295870363028525687085989951",
  "_score": null,
  "_source": {
    "@id": "33056800637449772331545945892295870363028525687085989951",
    "@timestamp": "2016-12-21T11:03:27.000Z",
    "@message": "Dec 21 11:03:27 ip-172-31-29-110 MyApp: INFO [2016-12-21 11:03:27,015] com.myapp.mapping.model.MyModel: ####### mycustom log file example",
  },
  "fields": {
    "@timestamp": [
      1482318207000
    ]
  },
  "sort": [
    1482318207000
  ]
}'