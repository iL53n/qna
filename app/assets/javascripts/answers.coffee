$(document).on 'turbolinks:load', () ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
      ,
    received: (data) ->
      if data.answer.user_id != gon.user_id
        $('.answers').append(JST["templates/answer"](data))
  });