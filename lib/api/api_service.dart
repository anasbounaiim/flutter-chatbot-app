import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _apiKey = 'API_key';
  final String _apiUrl = 'API_Link'; //https://api.openai.com/v1/chat/completions

  Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {"role": "system", "content": "Assistant for patients to declare incidents, take appointments, and ask for assistance."},
          {"role": "user", "content": prompt},
        ],
        'functions': [
          {
            'name': 'scheduleAppointment',
            'description': 'Schedules an appointment for the patient',
            'parameters': {
              'type': 'object',
              'properties': {
                'date': {
                  'type': 'string',
                  'description': 'The date and time for the appointment'
                },
                'doctor': {
                  'type': 'string',
                  'description': 'The name of the doctor'
                }
              },
              'required': ['date', 'doctor']
            }
          },
          {
            'name': 'reportIncident',
            'description': 'Reports an incident',
            'parameters': {
              'type': 'object',
              'properties': {
                'incidentType': {
                  'type': 'string',
                  'description': 'The type of incident'
                },
                'description': {
                  'type': 'string',
                  'description': 'A detailed description of the incident'
                }
              },
              'required': ['incidentType', 'description']
            }
          }
        ],
        'function_call': 'auto'  // Allow the model to decide if a function should be called
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to load response');
    }
  }
}