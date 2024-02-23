import 'package:saka/data/models/sos/sos.dart';

class SosRepo {
  List<SosModel> getSosList() {
    List<SosModel> sosList = [
      SosModel(id: 1, name: 'Ambulance', 
        icon: 'assets/icons/ic-ambulance.png', desc: 'Sebar permintaan tolong Ambulan',
        type: 'sos.emergency'
      ),
      SosModel(id: 2, name: 'Accident', 
        icon: 'assets/icons/ic-accident.png', desc: 'Sebar permintaan tolong Kecelakaan',
        type: 'sos.accident' 
      ),
      SosModel(
        id: 3, name: 'Trouble', 
        icon: 'assets/icons/ic-trouble.png', desc: 'Sebar permintaan tolong Mogok',
        type: 'sos.emergency'  
      ),
      SosModel(
        id: 3, name: 'Manual Guide', 
        icon: 'assets/icons/ic-manual-guide.png', desc: 'Dokumen komunikasi yang bertujuan memberikan bantuan untuk penggunaan suatu sistem',
        type: 'sos.emergency'  
      ),
    ];
    return sosList;
  }
}