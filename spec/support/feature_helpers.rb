module FeatureHelpers
  def log_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
  end

  def expect_sign_in_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  def data_id(answer)
    "[data-id='#{answer.id}']"
  end

  def add_files(*files)
    page.find('.edit').click

    files.each_with_index do |file, i|
      attach_file "question[attachments_attributes][#{i}][file]", file
    end

    click_on 'Save'
  end
end