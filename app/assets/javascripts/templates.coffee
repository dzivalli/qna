window.templates =
  answer: '''
    <div class="box" data-answer-id="<%= id %>">
      <div class="errors"></div>
      <div class="body answer">
        <div class="row">
          <div class="col-sm-1">
            <div class="sign">
              <% if ( best ) { %>
                <i class="fa fa-check-circle fa-4x"></i>
              <% } %>
            </div>
            <div class="score">
              <div class="row">
                <div class="votes"><%= votes %></div>
              </div>
              <div class="row">
                <a class="up" data-remote="true" href="/questions/<%= question_id %>/answers/<%= id %>/up"><i class="fa fa-plus"></i>
                </a>
                <a class="down" data-remote="true" href="/questions/<%= question_id %>/answers/<%= id %>/down"><i class="fa fa-minus"></i>
                </a>
              </div>
            </div>
          </div>
          <div class="col-sm-9">
            <li class="list-group-item">
              <div class="answer-body">
                <%= body %>
              </div>
              <div class="comments">
                <ul class="list-group">
                </ul>
                <a data-remote="true" href="/answers/219/comments/new">Add comment</a>
                <div class="errors"></div>
                <div class="comment-form"></div>
              </div>
              <br>
              <div class="attachments">
              </div>
              <div class="answer-controls">
              </div>
            </li>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-offset-1 col-sm-9">
          <div class="form" data-url="/questions/<%= question_id %>/answers/<%= id %>/edit"></div>
        </div>
      </div>
    </div>
  '''

  attachment: '''
    <p>
      <a href="<%= file.url %>"><%= name %></a>
    </p>
  '''

  question: '''
    <a class="list-group-item" href="/questions/<%= id %>"><h4 class="list-group-item-heading"><%= title %></h4>
    </a>
  '''

  answerControls: '''
    <a class="edit" href="/questions/<%= question_id %>/answers/<%= id %>/edit"><i class="fa fa-pencil"></i>
    </a>
    <a class="delete" data-remote="true" rel="nofollow" data-method="delete" href="/questions/<%= question_id %>/answers/<%= id %>"><i class="fa fa-trash"></i>
    </a>
    <a class="best" data-remote="true" href="/questions/<%= question_id %>/answers/<%= id %>/choice"><i class="fa fa-thumbs-o-up"></i>
    </a>
  '''