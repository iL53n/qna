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
      $('.answers').append(data)
});
