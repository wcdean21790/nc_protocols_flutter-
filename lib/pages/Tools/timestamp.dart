import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page/navigationbar.dart';

class TimeStampWidget extends StatefulWidget {
  @override
  _TimeStampWidgetState createState() => _TimeStampWidgetState();
}

class _TimeStampWidgetState extends State<TimeStampWidget> {
  int _selectedListIndex = 0;
  int _selectedItemIndex = -1;
  List<String> _timeStamps = [];

  final List<List<String>> _lists = [
    // Quick Access
    ['CPR Start','CPR Change','CPR End','Shock','ROSC','IV Access','Airway Device','IO Access','IV Saline','Saline Bolus'
    ],
    // Medication
    ['ACE Inhibitor', 'Acetaminophen', 'Adenosine', 'Aminophylline', 'Amiodarone', 'Anti-Arrythmic',
      'Antibiotics','Anti-emetic Preperation','Antiviral','Aspirin','Atropine','Barbiturates',
      'Benzodiazepines','Beta Agonist','Beta Blocker','Bretylium','C1 Esterase-Inhibitor','Calcium Channel Blocker',
      'Calcium Gluconate','Charcoal','Clonidine','Clopidogrel','CroFab','Crystalloid Solution','Cyanide Antidote','Digoxin','Diphenhydramine','Diuretics','Dobutamine','Dopamine','Droperidol','Epinephrine',
      'Etomidate','Flumazenil','Glucagon','Glucose - Oral','Glucose - Solutions','Haloperidol','Heparin',
      'Histamine 2 Blockers','Hydroxocobalamin','Immunizations','Insulin','Ipratropium','Isoproterenol','Ketamine',
      'Levetiracetam','Lidocaine','Magnesium Sulfate','Mannitol','Methylene Blue','Milrinone','N-Acetylcysteine',
      'Narcan','Nasal Decongestant','Nesiritide','Nitroglycerin','Nitroprusside Sodium','Nitrous Oxide',
      'Non-Prescription Medications','Non-steroidal anti-inflammatory','Norepinephrine','Octreotide','Oxygen',
      'Oxytocin','Paralytic Agent','Phenothiazine Preperation','Phenylehprine','Phenytoin Preperation',
      'Plasma Protein Factor','Platelet Inhibitor','Potassium Chloride','Pralidoxime','Procainamide','Procaine','Proparacaine',
      'Propofol','Proton Pump Inhibitor','Sodium Bicarbonate','Steroid Preparations','Thiamine','Thrombolytic Agents','Topical Hemostatic Agent',
      'Total Parenteral Nutrition','Tranexamic Acid (TXA)','Tuberculosis Skin Test','Valprocic Acid','Vasopressin'
    ],

    //Airway
    ['King/i-Gel Airway', 'BIAD', 'BMV','ET Tube','Nasal Cannula','NRB','Other'],

    //Procedures
    ['12-Lead ECG', 'Capnography', 'Cardioversion', 'Cricothyrotomy',
      'Defibrillation', 'Drug Assisted Airway', 'Endotracheal Tube Introducer', 'Foreign Body Obstruction', 'Intraosseous IV',
      'Intubation CO2 Detector', 'Intubation - Nasal', 'Intubation - Oral', 'IV', 'Laryngoscopy - Video', 'Mechanical CPR', 'Pacing',
      'Tracheostomy Tube Change'],
  ];

  // Button titles for categories
  final List<String> _buttonTitles = [
    'Quick Access',
    'Medication',
    'Airway',
    'Procedures',
  ];

  @override
  void initState() {
    super.initState();
    _loadTimeStamps(); // Load the timestamps when the widget is initialized
  }

  // Function to load time stamps from Shared Preferences
  Future<void> _loadTimeStamps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _timeStamps = prefs.getStringList('timeStamps') ?? [];
    });
  }

  // Function to save time stamps to Shared Preferences
  Future<void> _saveTimeStamps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('timeStamps', _timeStamps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242935),
      appBar: AppBar(
        backgroundColor: Color(0xFF242935),
        centerTitle: true,
        title: Text('Action Logger', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_buttonTitles.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedListIndex = index;
                          _selectedItemIndex = -1;
                        });
                      },
                      child: Text(
                        _buttonTitles[index],
                        style: TextStyle(
                          color: _selectedListIndex == index ? Colors.white : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedListIndex == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please choose action below to add to list',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 0, right: 25, left: 25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListView.builder(
                    itemCount: _lists[_selectedListIndex].length,
                    itemBuilder: (context, index) {
                      return Container(
                        key: UniqueKey(),
                        decoration: BoxDecoration(
                          color: _selectedItemIndex == index ? Colors.green : Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: index == _lists[_selectedListIndex].length - 1 ? 0 : 1),
                          ),
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              _lists[_selectedListIndex][index],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          selected: _selectedItemIndex == index,
                          selectedTileColor: Colors.green,
                          onTap: () {
                            setState(() {
                              _selectedItemIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _selectedItemIndex != -1
                  ? () {
                setState(() {
                  DateTime now = DateTime.now();
                  bool isDst = now.timeZoneOffset.isNegative && now.timeZoneOffset.inHours == -4;
                  DateTime estTime = now.subtract(Duration(hours: isDst ? 0 : 1));
                  var formatter = DateFormat("HH:mm MM/dd");
                  String formattedTime = formatter.format(estTime);

                  _timeStamps.add('${_lists[_selectedListIndex][_selectedItemIndex]} @ $formattedTime');
                  _saveTimeStamps(); // Save the timestamps whenever one is added
                });
              }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(_selectedItemIndex != -1 ? Colors.green : Colors.grey),
              ),
              child: Text('Add Time'),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.purpleAccent),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    itemCount: _timeStamps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(_timeStamps[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _timeStamps.removeAt(index);
                                  _saveTimeStamps(); // Save the updated list after deletion
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Clear'),
                          content: Text('Are you sure you want to clear the time stamps?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _timeStamps.clear();
                                  _saveTimeStamps(); // Save the cleared list
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomBar(),
    );
  }
}
