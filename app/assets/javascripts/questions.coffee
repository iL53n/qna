$(document).on 'turbolinks:load', () ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected!'
      @perform 'follow'
      ,
    received: (data) ->
      $('.questions').append(data)
  });
