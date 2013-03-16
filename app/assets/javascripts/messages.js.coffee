$ ->
  source = new EventSource('/messages/events')
  source.addEventListener 'messages.create', (e) ->
    message = $.parseJSON(e.data).message
    $('#chat').append($('<li>').text("#{message.name}: #{message.content}"))

  $('#new_message').on 'ajax:success', (data, status, xhr) ->
    $("#message_content").val('')
    top = $('#chat').scrollTop()
    $('#chat').scrollTop(top + 20)
