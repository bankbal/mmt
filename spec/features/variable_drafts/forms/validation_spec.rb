require 'rails_helper'

describe 'Variable Drafts Forms Field Validations', reset_provider: true, js: true do
  before do
    login

    @draft = create(:empty_variable_draft, user: User.where(urs_uid: 'testuser').first)
  end

  context 'required fields' do
    before do
      visit edit_variable_draft_path(@draft)
    end

    context 'when trying to submit a form with required fields' do
      context 'when the fields are empty' do
        before do
          within '.nav-top' do
            click_on 'Save'
          end
        end

        it 'displays a modal with a prompt about saving invalid data' do
          expect(page).to have_content('This page has invalid data. Are you sure you want to save it and proceed?')
        end
      end

      context 'when the fields are filled' do
        before do
          fill_in 'Name', with: 'Test Var Short Name'
          fill_in 'Definition', with: 'Definition of test variable'
          fill_in 'Long Name', with: 'Test Var Long Long Name'
          fill_in 'Scale', with: '2'
          fill_in 'Offset', with: '5'

          within '.nav-top' do
            click_on 'Save'
          end
        end

        it 'saves the form without a modal prompt' do
          expect(page).to have_no_content('This page has invalid data. Are you sure you want to save it and proceed?')
          expect(page).to have_content('Variable Draft Updated Successfully!')
        end

        it 'populates the form with the data' do
          expect(page).to have_field('Name', with: 'Test Var Short Name')
          expect(page).to have_field('Definition', with: 'Definition of test variable')
          expect(page).to have_field('Long Name', with: 'Test Var Long Long Name')
          expect(page).to have_field('Scale', with: '2.0')
          expect(page).to have_field('Offset', with: '5.0')
        end
      end
    end

    context 'when visiting required fields' do
      context 'when no data is entered into the field' do
        before do
          find('#variable_draft_draft_name').click
          find('#variable_draft_draft_long_name').click
          find('#variable_draft_draft_units').click
        end

        it 'displays validation error messages' do
          expect(page).to have_css('.eui-banner--danger', count: 3)

          expect(page).to have_css('#umm-form-errors')
          within '#umm-form-errors' do
            expect(page).to have_content('This draft has the following errors:')
            expect(page).to have_content('Name is required')
            expect(page).to have_content('Long Name is required')
          end

          expect(page).to have_css('#variable_draft_draft_name-error', text: 'Name is required')
          expect(page).to have_css('#variable_draft_draft_long_name-error', text: 'Long Name is required')
        end
      end

      context 'when data is entered into the field' do
        before do
          fill_in 'Name', with: 'Test Var Short Name'
          fill_in 'Long Name', with: 'Test Var Long Long Name'
          find('#variable_draft_draft_units').click
        end

        it 'does not display validation error messages' do
          expect(page).to have_no_css('.eui-banner--danger')
        end
      end
    end
  end

  context 'number fields' do
    before do
      visit edit_variable_draft_path(@draft)
    end

    context 'when entering text into a number field' do
      before do
        fill_in 'Min', with: 'abcd'
        fill_in 'Max', with: 'abcd'
        fill_in 'Scale', with: 'abcd'
        fill_in 'Offset', with: 'abcd'

        find('#variable_draft_draft_units').click
      end

      it 'displays validation error messages' do
        expect(page).to have_css('.eui-banner--danger', count: 5)

        expect(page).to have_css('#umm-form-errors')
        within '#umm-form-errors' do
          expect(page).to have_content('Min must be a number')
          expect(page).to have_content('Max must be a number')
          expect(page).to have_content('Scale must be a number')
          expect(page).to have_content('Offset must be a number')
        end

        expect(page).to have_css('#variable_draft_draft_valid_range_0_min-error', text: 'Min must be a number')
        expect(page).to have_css('#variable_draft_draft_valid_range_0_max-error', text: 'Max must be a number')
        expect(page).to have_css('#variable_draft_draft_scale-error', text: 'Scale must be a number')
        expect(page).to have_css('#variable_draft_draft_offset-error', text: 'Offset must be a number')
      end

      context 'when saving the form' do
        before do
          within '.nav-top' do
            click_on 'Save'
          end
        end

        it 'displays a modal with a prompt about saving invalid data' do
          expect(page).to have_content('This page has invalid data. Are you sure you want to save it and proceed?')
        end
      end
    end
  end
end
