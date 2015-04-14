window.answer = '''
  <div class="box" data-id="<%= id %>">
    <div class="errors"></div>
    <div class="body answer">
      <div class="row">
        <div class="col-sm-1">
          <div class="sign">
          </div>
        </div>
        <div class="col-sm-9">
          <li class="list-group-item">
            <div class="answer-body">
              <%= body %>
            </div>
            <br>
            <div class="attachments">
            </div>
            <a class="edit" href="/questions/<%= question_id %>/answers/<%= id %>/edit"><i class="fa fa-pencil"></i>
            </a>
            <a class="delete" data-remote="true" rel="nofollow" data-method="delete" href="/questions/<%= question_id %>/answers/<%= id %>"><i class="fa fa-trash"></i>
            </a>
            <a class="best" data-remote="true" href="/questions/<%= question_id %>/answers/<%= id %>/choice"><i class="fa fa-thumbs-o-up"></i>
            </a>
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

window.attachment = '''
  <p>
    <a href="<%= file.url %>"><%= name %></a>
  </p>
'''