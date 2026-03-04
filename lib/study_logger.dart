import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic_rag_frontend/state/pipeline_cubit.dart';

import 'api/mosaic_rs.dart';

class StudyLogger {
  // 1. Singleton Setup
  static final StudyLogger _instance = StudyLogger._internal();

  factory StudyLogger() {
    return _instance;
  }

  StudyLogger._internal();

  // 2. Configuration State
  String _serverUrl = "https://data-logger.felixholz.com/api/logs";
  String? _userId = Uri.base.queryParameters['user_id'] ??
      Uri.base.queryParameters['userid'] ??
      Uri.base.queryParameters['userID'];
  String? _pipelineId = Uri.base.queryParameters['id'];

  /// The internal helper that actually sends the HTTP request
  Future<void> _send(
    String eventType,
    String pipelineState,
    Map<String, dynamic> eventSpecificData,
  ) async {
    // Combine common fields with event-specific fields
    final body = {
      // Common Fields
      'timestamp': DateTime.now().toIso8601String(),
      'url': Uri.base.origin,
      'user_id': _userId,
      'pipeline_id': _pipelineId,
      'pipeline_state': pipelineState, // Expecting a JSON string here
      'event_type': eventType,

      // Spread the specific fields (e.g., query, doc_id) into the root
      ...eventSpecificData,
    };

    try {
      // Fire and forget (don't await strictly unless debugging)
      http
          .post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
          .then((response) {
        if (response.statusCode != 200) {
          print("⚠️ StudyLogger: Server rejected log (${response.statusCode})");
        }
      });
    } catch (e) {
      print("⚠️ StudyLogger: Network error $e");
    }
  }

  // ===========================================================================
  // Specific Event Methods
  // ===========================================================================

  void logClickDocument({
    required String documentUrl,
    required String documentId,
    required String pipelineState,
  }) {
    _send('click_document', pipelineState, {
      'document_url': documentUrl,
      'document_id': documentId,
    });
  }

  void logAddPipelineStep({
    required String stepName,
    required String pipelineState,
  }) {
    _send('add_pipeline_step', pipelineState, {
      'step_name': stepName,
    });
  }

  void logRemovePipelineStep({
    required String stepName,
    required String pipelineState,
  }) {
    _send('remove_pipeline_step', pipelineState, {
      'step_name': stepName,
    });
  }

  void logOpenSite() {
    _send('open_site', '', {});
  }

  void logMakeSearch({
    required String query,
    required String pipelineState,
  }) {
    _send('make_search', pipelineState, {
      'query': query,
    });
  }

  void logStartChat({
    required String documents,
    required String pipelineState,
  }) {
    // Join list into a comma-separated string as requested
    _send('start_chat', pipelineState, {
      'documents': documents,
    });
  }

  void logSendChat({
    required String documents,
    required String message,
    required String pipelineState,
  }) {
    _send('send_chat', pipelineState, {
      'documents': documents,
      'chat_message': message,
    });
  }

  void logClickLink({
    required String linkUrl,
    required String documentId,
    required String pipelineState,
  }) {
    _send('click_link', pipelineState, {
      'document_url': linkUrl,
      'document_id': documentId,
    });
  }

  void logChangeTextColumn({
    required String previousColumn,
    required String nextColumn,
    required String pipelineState,
  }) {
    _send('change_text_column', pipelineState, {
      'previous_text_column': previousColumn,
      'next_text_column': nextColumn,
    });
  }

  void logChangeRankColumn({
    required String previousColumn,
    required String nextColumn,
    required String pipelineState,
  }) {
    _send('change_rank_column', pipelineState, {
      'previous_rank_column': previousColumn,
      'next_rank_column': nextColumn,
    });
  }

  void logViewLogs({
    required String pipelineState,
  }) {
    _send('view_logs', pipelineState, {});
  }

  String getPipelineState(context) {
    final pipeline = BlocProvider.of<PipelineCubit>(context).state.currentSteps;

    String jsonData = MosaicRS.getPipelineJSON(pipeline, {});

    return jsonData;
  }
}
