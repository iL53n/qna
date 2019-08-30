$(document).on('turbolinks:load', function() {
  $('.question').on('ajax:success', function () {
    subscription('.question_subscription')
  });
});

function subscription(resource) {
  $(resource).find('.unsubscribe').toggle()
  $(resource).find('.subscribe').toggle()
}