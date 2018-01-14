( function(Fork, $) {

  Fork.show_details = function() {
    var details = $(event.target).data('details');

    $.ajax({
      type: "POST",
      url: '/fork/show_details',
      data: {details: details}
    }).success(function(html){
      $('#details').html(html);
    });
  };


  $(function() {
    $('#currencies').submit(function() {
      $('#currencies button').prop('disabled', true);

      var valuesToSubmit = $(this).serialize();
      $.ajax({
        type: "GET",
        url: '/fork/find_forks',
        data: valuesToSubmit
      }).success(function(html){
        $('#forks').html(html);
      }).always(function(){
        $('#currencies button').prop('disabled', false);
      });
      return false;
    });
  });

})(window.Fork = window.Fork || {}, jQuery);