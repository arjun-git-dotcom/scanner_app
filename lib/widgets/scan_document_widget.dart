import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:scanning_app/pages/details_page.dart';

//
//surnameinnationallang
//edition =date of issue
//type not direclty like identity card but code like"ID"
//status
// final checkDigitsValidity = {
//   "documentNumberCheckDigitValid": mrz?.documentNumberCheckDigitValid,
//   "dateOfBirthCheckDigitValid": mrz?.dateOfBirthCheckDigitValid,
//   "dateOfExpiryCheckDigitValid": mrz?.dateOfExpiryCheckDigitValid,
//   "compositeCheckDigitValid": mrz?.compositeCheckDigitValid,
// };

class ScanDocumentWidget {
  final BuildContext context;
  ScanDocumentWidget({required this.context});

  Future<void> scanDocument() async {
    DocumentReader.instance.startScanner(
      ScannerConfig.withScenario(Scenario.MRZ),
      (action, results, error) async {
        if (action == DocReaderAction.COMPLETE ||
            action == DocReaderAction.TIMEOUT) {
          if (results != null) {
            var name = await results.textFieldValueByType(
              FieldType.SURNAME_AND_GIVEN_NAMES,
            );
            var nationality = await results.textFieldValueByType(
              FieldType.NATIONALITY,
            );
            var dateofbirth = await results.textFieldValueByType(
              FieldType.DATE_OF_BIRTH,
            );
            var gender = await results.textFieldValueByType(FieldType.SEX);
            var personalNumber = await results.textFieldValueByType(
              FieldType.PERSONAL_NUMBER,
            );
            var issueDate = await results.textFieldValueByType(
              FieldType.DATE_OF_ISSUE,
            );
            var issuingAuhtority = await results.textFieldValueByType(
              FieldType.ISSUING_STATE_NAME,
            );

            print('issuingauthority :$issuingAuhtority');

            var dateofexpiry = await results.textFieldValueByType(
              FieldType.DATE_OF_EXPIRY,
            );
            print('dateofexpiry:$dateofexpiry');

            var documentcode = await results.textFieldValueByType(
              FieldType.DOCUMENT_CLASS_CODE,
            );

            print(documentcode);

            var documetnNumber = await results.textFieldValueByType(
              FieldType.DOCUMENT_NUMBER,
            );

            print(documetnNumber);

            var placeofbirth = await results.textFieldValueByType(
              FieldType.PLACE_OF_BIRTH,
            );

            print(placeofbirth);

            var mothersname = await results.textFieldValueByType(
              FieldType.MOTHERS_NAME,
            );

            var countrycode = await results.textFieldValueByType(
              FieldType.ISSUING_STATE_CODE,
            );

            
          

            print(countrycode);

            print(mothersname);

            var nationalityvisualzone = await results.textFieldValueByType(
              FieldType.NATIONALITY,
            );
            print(nationalityvisualzone);

            var mrz = await results.textFieldValueByType(FieldType.MRZ_STRINGS);
            print(mrz);

            var fathersname = await results.textFieldValueByType(
              FieldType.FATHERS_NAME,
            );
            print(fathersname);

            print(fathersname);

            var age = await results.textFieldValueByType(FieldType.AGE);

            print(age);

            var fullname = await results.textFieldValueByType(
              FieldType.SURNAME_AND_GIVEN_NAMES,
            );

            print(fullname);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    name: name ?? "No Name",
                    nationality: nationality ?? "No Nationality Specified",
                    dateofbirth: dateofbirth ?? "No Date Of Birth Specified",
                    gender: gender ?? "No Gender Specified",
                    personalNumber:
                        personalNumber ?? "No Personal Number Specified",
                    issueDate: issueDate ?? "No Date of Issue specified",
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}
