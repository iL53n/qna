$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e) {
    var object = e.detail[0];
    rating('.question', object)
  });

  $('.answers').on('ajax:success', function(e) {
    var object = e.detail[0];
    var answer = $('.answer_' + object['id']);
    rating(answer, object)
  })
});

function rating(resource, object) {
  $(resource).find('.rating').html('<p>' + object['rating'] + '</p>')
  $(resource).find('.cancel_vote').toggle()
  $(resource).find('.change_vote').toggle()
}