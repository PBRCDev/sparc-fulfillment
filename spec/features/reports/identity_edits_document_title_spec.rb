require 'rails_helper'

feature 'Identity edits document title', js: true, enqueue: false do

  context "from the All Reports page" do
    context "when creating a report" do
      scenario "and sees the custom title" do
        given_i_am_viewing_the_all_reports_page
        when_i_create_an_identity_based_document_with_a_custom_title
        then_i_should_see_the_title_has_been_updated
      end
    end

    scenario "and sees the title has changed" do
      given_i_am_viewing_the_all_reports_page_with_documents
      when_i_edit_the_title
      then_i_should_see_the_title_has_been_updated
    end
  end

  context "from the Reports Tab" do
    scenario "and sees the title has changed" do
      given_i_am_viewing_the_reports_tab_with_documents
      when_i_edit_the_title
      then_i_should_see_the_title_has_been_updated
    end
  end

  def given_i_am_viewing_the_all_reports_page
    @protocol = create_and_assign_protocol_to_me

    visit documents_path
    wait_for_ajax
  end

  def given_i_am_viewing_the_all_reports_page_with_documents
    @protocol = create_and_assign_protocol_to_me
    create(:document_of_identity_report, documentable_id: Identity.first.id)

    visit documents_path
    wait_for_ajax
  end

  def given_i_am_viewing_the_reports_tab_with_documents
    @protocol    = create_and_assign_protocol_to_me
    create(:document_of_protocol_report, documentable_id: @protocol.id)

    visit protocol_path @protocol
    wait_for_ajax

    click_link 'Reports'
    wait_for_ajax
  end

  def when_i_create_an_identity_based_document_with_a_custom_title
    find("[data-type='invoice_report']").click
    wait_for_ajax

    fill_in 'Title', with: "A custom title"
    page.execute_script %Q{ $("#start_date").trigger("focus")}
    page.execute_script %Q{ $("td.day:contains('10')").trigger("click") }
    page.execute_script %Q{ $("#end_date").trigger("focus")}
    page.execute_script %Q{ $("td.day:contains('10')").trigger("click") }

    # close calendar thing, so it's not covering protocol dropdown
    find(".modal-header", match: :first).click
    wait_for_ajax

    find('button.multiselect').click
    check(@protocol.organization.name)

    # close organization dropdown, so it's not covering protocol dropdown
    find(".modal-header", match: :first).click
    wait_for_ajax

    expect(page).to have_selector('.modal-body .bootstrap-select button.selectpicker', visible: true)
    bootstrap_select '#protocol_ids', @protocol.short_title_with_sparc_id

    # close protocol dropdown, so it's not covering 'Request Report' button
    find('.modal-header', match: :first).click
    wait_for_ajax
    find("input[type='submit']").click
    wait_for_ajax
  end

  def when_i_edit_the_title
    first("a.edit-document").click
    wait_for_ajax

    fill_in 'Title', with: "A custom title"

    find("button[type='submit']").click
    wait_for_ajax
  end

  def then_i_should_see_the_title_has_been_updated
    expect(page).to have_css('table tbody tr td', text: "A custom title")
  end
end