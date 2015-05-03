# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require templates
init = ->
  $('body').on 'click', '.edit', (e) ->
    e.preventDefault()
    box = $(this).closest('.box')
    form = box.find('.form')
    url = form.data 'url'
    $.get url, (data) ->
      box.find('.body').hide()
      form.html(data)

  $('body').on 'click', '.button-close', (e) ->
    e.preventDefault()
    box = $(this).closest('.box')
    box.find('.body').show()
    box.find('form').hide()
    box.find('.errors').html('')

  $('body').on 'change', '.file_fields input:file', (e) ->
    all_buttons = $(this).closest('.box').find('.file_fields input:file')
    if this == all_buttons.last()[0]
      id = parseInt(all_buttons.last().attr('name').match(/\d+/)[0]) + 1
      obj = $(this).closest('form').attr('id').split('_')[1]
      name = "#{obj}[attachments_attributes][#{id}][file]"
      new_button = $("<input class='file_field' type='file' name=#{name}>")
      all_buttons.last().after(new_button)

  $('body').on 'click', '.delete-attachment', (e) ->
    e.preventDefault()
    id = $(this).data('destroy')
    $(this).parent('p').siblings("input[data-destroy=#{id}]").prop('checked', true)
    $(this).parent('p').remove()

  subscribe_to_new_answers()
  subscribe_to_new_questions()


#  $('.list-group').on 'ajax:success', 'form.answer-form', (e, answer, status) ->
#    $(this).closest('.box').replaceWith(generate_answer(answer))
#  .on 'ajax:error', 'form.answer-form',  ajax_error

  $('body').on 'ajax:success', '.score a', (e, votes, status) ->
    $(this).closest('.score').find('.votes').html(votes)

ajax_error = (e, xhr, status, error) ->
  $this = $(this)
  errors = xhr.responseJSON
  if errors
    $.each errors, (key, value) ->
      $this.find('.errors').html(value)

subscribe_to_new_answers = ->
  questionId = $('.question').data('question-id')
  PrivatePub.subscribe "/questions/#{questionId}/answers", (data, channel) ->
    answer = JSON.parse data.answer
    $('.list-group.answers').append(generate_answer(answer))
    clean($('form.new_answer'))

subscribe_to_new_questions= ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    question = data.question
    question_template = _.template window.templates.question
    $('.list-group').append(question_template(question))

generate_answer = (answer) ->
  answer_template = _.template window.templates.answer
  full_answer = $(answer_template(answer))

  if answer.attachments
    attachment_template = _.template window.templates.attachment
    attachments_html = ''
    $.each answer.attachments, (key, value) ->
      value['name'] = value.file.url.split('/').pop()
      attachments_html += attachment_template(value)
    full_answer.find('.attachments').html(attachments_html)

  userId = parseInt Cookies.get('user_id')
  if userId == answer.user_id
    answer_controls_template = _.template window.templates.answerControls
    full_answer.find('.answer-controls').html(answer_controls_template(answer))

  full_answer

clean = ($form) ->
  $form.find('textarea').val('')
  $form.find('.errors').html('')
  $form.find('input:file').each ->
    $(this).remove() unless $(this).attr('id')

$(document).ready init
$(document). on 'page:load', init