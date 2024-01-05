import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputExpansionPanelChoices extends StatefulWidget {
  const ArtifactInputExpansionPanelChoices({
    required this.onSelectionChanged,
    this.initialSelections,
    Key? key,
  }) : super(key: key);

  // accepts prepopulated param for inserting selected choices.

  final List<String>? initialSelections;
  final Function(List<String>) onSelectionChanged;

  @override
  State<ArtifactInputExpansionPanelChoices> createState() => _ArtifactInputExpansionPanelChoicesState();
}

class _ArtifactInputExpansionPanelChoicesState extends State<ArtifactInputExpansionPanelChoices> {
  List<String> standardsPanelsHeaders = [
    'Practices for K-12 Science Classrooms',
    'Crosscutting Concepts',
    'Core Ideas in Physical Sciences',
    'Core Ideas in Life Sciences',
    'Core Ideas in Earth and Space Science',
    'Core Ideas in Engineering, Technology and the Application of Science',
  ];

  late int panelCount;

  List<bool> allClosedTogglers = [];

  List<int> standardsPanelsHeadersRange = [];

  List<String> selectedChoices = [];

  List<bool> _isOpen = [];

  static const sectionBottomGap = 60.0;

  @override
  void initState() {
    selectedChoices =  widget.initialSelections ?? [];
    super.initState();

    panelCount = standardsPanelsHeaders.length;

    // result will look like `[false,false,...]`
    allClosedTogglers = List<bool>.filled(panelCount, false, growable: true);
    _isOpen = [...allClosedTogglers];
    standardsPanelsHeadersRange = Iterable<int>.generate(panelCount).toList();
  }


  Container bodyFromHeaders(int index) {
    List<String> standardsPanelChoicesFirst = [
      'Asking questions (for science) and defining problems (for engineering)',
      'Developing and using models',
      'Planning and carrying out investigations',
      'Analyzing and interpreting data',
      'Using Mathematics and Computational Thinking',
      'Constructing explanations (for science) and designing solutions (for engineering)',
      'Engaging in argument from evidence',
      'Obtaining, evaluating, and communicating information',
    ];

    List<String> standardsPanelChoicesSecond = [
      'Patterns',
      'Cause and Effect',
      'Scale, Proportion, and Quantity',
      'Systems and System Models',
      'Energy and Matter',
      'Structure and Function',
      'Stability and Change',
    ];

    List<String> standardsPanelChoicesThirdSectionFirst = [
      'PS1.A: Structure and Properties of Matter',
      'PS1.B: Chemical Reactions',
      'PS1.C: Nuclear Processes',
    ];

    List<String> standardsPanelChoicesThirdSectionSecond = [
      'PS2.A: Forces and Motion',
      'PS2.B: Types of Interactions',
      'PS2.C: Stability and Instability in Physical Systems',
    ];

    List<String> standardsPanelChoicesThirdSectionThird = [
      'PS3.A: Definitions of Energy',
      'PS3.B: Conservation of Energy and Energy Transfer',
      'PS3.C: Relationship Between Energy and Forces',
      'PS3.D: Energy in Chemical Processes and Everyday Life',
    ];

    List<String> standardsPanelChoicesThirdSectionFourth = [
      'PS4.A: Wave Properties',
      'PS4.B: Electromagnetic Radiation',
      'PS4.C: Information Technologies and Instrumentation',
    ];

    List<String> fourthSectionHeaders = [
      'Core Idea LS1: From Molecules to Organisms: Structures and Processes',
      'Core Idea LS2: Ecosystems: Interactions, Energy, and Dynamics',
      'Core Idea LS3: Heredity: Inheritance and Variation of Traits',
      'Core Idea LS4: Biological Evolution: Unity and Diversity',
    ];

    List<List<String>> fourthSectionChoices = [
      [
        'LS1.A: Structure and Function',
        'LS1.B: Growth and Development of Organisms',
        'LS1.C: Organization for Matter and Energy Flow in Organisms',
        'LS1.D: Information Processing',
      ],
      [
        'LS2.A: Interdependent Relationships in Ecosystems',
        'LS2.B: Cycles of Matter and Energy Transfer in Ecosystems',
        'LS2.C: Ecosystem Dynamics, Functioning, and Resilience',
        'LS2.D: Social Interactions and Group Behavior',
      ],
      [
        'LS3.A: Inheritance of Traits',
        'LS3.B: Variation of Traits',
      ],
      [
        'LS4.A: Evidence of Common Ancestry and Diversity',
        'LS4.B: Natural Selection',
        'LS4.C: Adaptation',
        'LS4.D: Biodiversity and Humans',
      ],
    ];


    List<String> fifthSectionHeaders = [
      'Core Idea ESS1: Earth’s Place in the Universe',
      'Core Idea ESS2: Earth’s Systems',
      'Core Idea ESS3: Earth and Human Activity',
    ];

    List<List<String>> fifthSectionChoices = [
      [
        'ESS1.A: The Universe and Its Stars',
        'ESS1.B: Earth and the Solar System',
        'ESS1.C: The History of Planet Earth',
      ],
      [
        'ESS2.A: Earth Materials and Systems',
        'ESS2.B: Plate Tectonics and Large-Scale System Interactions',
        'ESS2.C: The Roles of Water in Earth’s Surface Processes',
        'ESS2.D: Weather and Climate',
        'ESS2.E: Biogeology',
      ],
      [
        'ESS3.A: Natural Resources',
        'ESS3.B: Natural Hazards',
        'ESS3.C: Human Impacts on Earth Systems',
        'ESS3.D: Global Climate Change',
      ],
    ];


    List<String> sixthSectionHeaders = [
      'Core Idea ETS1: Engineering Design',
    ];

    List<List<String>> sixthSectionChoices = [
      [
        'ETS1.A: Defining and Delimiting Engineering Problems',
        'ETS1.B: Developing Possible Solutions',
        'ETS1.C: Optimizing the Design Solution',
      ],
    ];

    Container _body;

    CheckboxListTile checkboxFromLabel(String label) {
      bool isSelected = selectedChoices.contains(label);

      return CheckboxListTile(
        title: Text(label, style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        )),
        controlAffinity: ListTileControlAffinity.leading,
        value: isSelected,
        onChanged: (bool? value) {
          setState(() {
            value!
                ? selectedChoices.add(label)
                : selectedChoices.remove(label);
            widget.onSelectionChanged(selectedChoices);
          });
        },
      );
    }

    Container subHeadingFromLabel(String label) {
      return Container(
        color: buttonBGDisabledGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
      );
    }
    Column checkboxesColumnFromLabels(List<String> items) {
      return Column(
        children: items.map<CheckboxListTile>(checkboxFromLabel).toList(),
      );
    }

    _body = Container(child: Text('undefined subheading range'));

    switch (index) {
      case 0:
        _body = Container(
          child: checkboxesColumnFromLabels(standardsPanelChoicesFirst),
        );
        break;
      case 1:
        _body = Container(
          child: checkboxesColumnFromLabels(standardsPanelChoicesSecond),
        );
        break;
      case 2:
        _body = Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              subHeadingFromLabel('Core Idea PS1: Matter and Its Interactions'),
              checkboxesColumnFromLabels(standardsPanelChoicesThirdSectionFirst),
              subHeadingFromLabel('Core Idea PS2: Motion and Stability: Forces and Interactions'),
              checkboxesColumnFromLabels(standardsPanelChoicesThirdSectionSecond),
              subHeadingFromLabel('Core Idea PS3: Energy'),
              checkboxesColumnFromLabels(standardsPanelChoicesThirdSectionThird),
              subHeadingFromLabel('Core Idea PS4: Waves and Their Applications in Technologies for Information Transfer'),
              checkboxesColumnFromLabels(standardsPanelChoicesThirdSectionFourth),
              SizedBox(height: sectionBottomGap),
            ],
          ),
        );
        break;
      case 3:
        List<Widget> fourthSectionWidgets = [];

        for (int i = 0; i < fourthSectionHeaders.length; i++) {
          fourthSectionWidgets.add(subHeadingFromLabel(fourthSectionHeaders[i]));
          fourthSectionWidgets.add(checkboxesColumnFromLabels(fourthSectionChoices[i]));
        }
        _body = Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...fourthSectionWidgets,
              SizedBox(height: sectionBottomGap),
            ],
          ),
        );
        break;
      case 4:
        List<Widget> fifthSectionWidgets = [];

        for (int i = 0; i < fifthSectionHeaders.length; i++) {
          fifthSectionWidgets.add(subHeadingFromLabel(fifthSectionHeaders[i]));
          fifthSectionWidgets.add(checkboxesColumnFromLabels(fifthSectionChoices[i]));
        }
        _body = Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...fifthSectionWidgets,
              SizedBox(height: sectionBottomGap),
            ],
          ),
        );
        break;
      case 5:
        List<Widget> sixthSectionWidgets = [];

        for (int i = 0; i < sixthSectionHeaders.length; i++) {
          sixthSectionWidgets.add(subHeadingFromLabel(sixthSectionHeaders[i]));
          sixthSectionWidgets.add(checkboxesColumnFromLabels(sixthSectionChoices[i]));
        }
        _body = Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...sixthSectionWidgets,
              SizedBox(height: sectionBottomGap),
            ],
          ),
        );
        break;
    }

    return _body;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isOpen.setAll(0, allClosedTogglers);
          _isOpen[index] = !isExpanded;
        });
      },
      children: standardsPanelsHeadersRange.map<ExpansionPanel>((index) {
        String item = standardsPanelsHeaders[index];
        return ExpansionPanel(
          body: bodyFromHeaders(index),
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item, style: TextStyle(
                color: primaryButtonBlue,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            );
          },
          isExpanded: _isOpen[index],
        );
      }).toList(),
    );
  }
}