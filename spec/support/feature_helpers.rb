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

  def add_files(selector, *files)
    obj = selector == '.question' ? 'question' : 'answer'

    within selector do
      page.find('.edit').click

      files.each_with_index do |file, i|
        attach_file "#{obj}[attachments_attributes][#{i}][file]", file
      end

      click_on 'Save'
    end
  end

  def expect_change_vote_by_1_after_2_click_on_up
    2.times do
      page.find('.up').click

      within '.score' do
        expect(page).to have_content '1'
      end
    end
  end

  def expect_change_vote_by_minus_1_after_2_click_on_up
    2.times do
      page.find('.down').click

      within '.score' do
        expect(page).to have_content '-1'
      end
    end
  end

  def expect_vote_to_undo_after_click_on_up
    page.find('.up').click
    page.find('.down').click

    within '.score' do
      expect(page).to have_content '0'
    end
  end

  def expect_vote_to_undo_after_click_do_down
    page.find('.down').click
    page.find('.up').click

    within '.score' do
      expect(page).to have_content '0'
    end
  end

  def vote_up_by(user, selector)
    log_in user

    visit question_path(question)

    within selector do
      page.find('.up').click
    end

    click_on 'Sign out'
  end

  def vote_down_by(user, selector)
    log_in user

    visit question_path(question)

    within selector do
      page.find('.down').click
    end

    click_on 'Sign out'
  end
end